defmodule Translate do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.cognitive.microsofttranslator.com"
  plug Tesla.Middleware.Headers, [
    {"Ocp-Apim-Subscription-Key", Dotenv.get("SUBSCRIPTION_KEY")},
    {"Ocp-Apim-Subscription-Region", Dotenv.get("SUBSCRIPTION_REGION")},
    {"content-type", "application/json"}
  ]
  plug Tesla.Middleware.JSON

  defp parse_translation(content) do
    content 
    |> hd
    |> Map.get("translations")
    |> hd
    |> Map.get("text")
  end

  def translate(content, model) do
    {:ok, content} = post("/translate?api-version=3.0&from=#{model.original_language}&to=#{model.translated_language}", ~s'[{"Text": "#{content}"}]')

    parse_translation(content.body)
  end
end

defmodule App do
  @behaviour Ratatouille.App

  import Ratatouille.View
  import Ratatouille.Constants, only: [key: 1]

  @spacebar key(:space)

  @delete_keys [
    key(:delete),
    key(:backspace),
    key(:backspace2)
  ]

  @enter key(:enter)

  @translate key(:ctrl_t)

  @languages [
    :en,
    :de,
    :ja,
  ]

  def init(_context) do
    %{
      counter: 0,
      original_language: :en,
      translated_language: :ja,
      original: "",
      translated: "",
    }
  end

  def update(model, msg) do
    case msg do
      {:event, %{key: key}} when key in @delete_keys ->
        %{model | original: String.slice(model.original, 0..-2)}

      {:event, %{key: @spacebar}} ->
        %{model | original: model.original <> " "}

      {:event, %{key: @translate}} ->
        %{model | translated: model.original |> Translate.translate model}
        
      {:event, %{key: @enter}} ->
        %{model | original: model.original <> "\n"}

      {:event, %{ch: ch}} when ch > 0 ->
        %{model | original: model.original <> <<ch::utf8>>}

      _ -> model
    end
  end

  def render(model) do
    controls = bar do 
      label(content: "<C-d>: Quit application, <C-t>: Translate text") 
    end

    view(
      bottom_bar: controls
    ) do
      row do
        column(size: 6) do
          panel(title: "Original - #{Atom.to_string(model.original_language)}", height: :fill) do
            label(content: model.original, wrap: true)
          end
        end
        column(size: 6) do
          panel(title: "Translated - #{Atom.to_string(model.translated_language)}", height: :fill) do
            label(content: model.translated, wrap: true)
          end
        end
      end
    end
  end
end

Ratatouille.run(
  App,
  quit_events: [
    {:key, Ratatouille.Constants.key(:ctrl_d)}
  ]
)
