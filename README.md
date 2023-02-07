# Translate-exs - Text translator within your terminal

Translate-exs is a terminal translator built entirely in Elixir. This project uses [Azure Translator](https://azure.microsoft.com/en-us/products/cognitive-services/translator) to handle the translations, this means you will need to create an account and use your respective tokens to run the application. 


## Screenshots

![Example translation](https://github.com/BrookJeynes/translation-exs/blob/main/assets/example.png)


## Features

- Translate to and from a variety of languages
- Built within the terminal for easy access


## Run Locally

1. Clone the project

```bash
  git clone https://github.com/BrookJeynes/translate-exs
```

2. Go to the project directory

```bash
  cd translate-exs
```

3. Set up environment variables
```bash
  cat .env
  echo "SUBSCRIPTION_KEY=<key-here>\nSUBSCRIPTION_REGION=<region-here>" > .env
```

4. You will need to have python 2.7 installed and accessable via `python`.
  - MacOS instructions: https://stackoverflow.com/a/67274521/21000191

5. Start the application

```bash
  mix run lib/translate_exs.ex --help 
```
