# CoinbaseApi

Wrote up this client to interact with the Coinbase API. There are several functions that one can just copy from to use in their project. This project eliminates the hurdles that come when starting to use the API. I've spent many an hours running into errors before even being able to use any of the secured endpoints.

PRs and issues to enhance or improve this project are always welcome! 🙌

Make sure you have the relevant credentials for the relevant environment. Add your credentials in [config/config.exs](./config/config.exs).

Note that the docs are not fully clear and you may run into errors to setup using the API. They're not updated and the answers on StackOverflow are from an older version of the API.

Run the tests and observe the error messages.
Apparently, even the routes are different depending upon the environment.

The Node.js files are used to debug why requests fail. Best to keep them.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `coinbase_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:coinbase_api, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/coinbase_api>.


If not available in Hex, simply clone this repo and start using it in your projects.


### Contributing
#### Here's how you can contribute to the project:
- Open up issues.
- Open up pull requests.
- Fix bugs in the code.
- Help with the documentation.
- Suggest features.
- Test the client and suggest improvements.

### Reach out to me on:
1. Twitter [@neverloquacious](https://www.twitter.com/neverloquacious)
2. Email <kevinam99@gmail.com>
3. LinkedIn [Kevin Mathew](https://www.linkedin.com/in/kevin-a-mathew)

