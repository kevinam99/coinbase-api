defmodule CoinbaseApi do
  @moduledoc """
  Documentation for `CoinbaseApi`.
  """
  # coinbase prod credentials
  @api_key Application.fetch_env!(:coinbase_api, :api_key)
  @api_secret Application.fetch_env!(:coinbase_api, :api_secret)
  @url "https://api.coinbase.com"
  @env :prod

  @api_version "2019-11-15"
  #@passphrase Application.fetch_env!(:coinbase_api, :passphrase)

  def buy_and_send() do
    buy_crypto(0.0000000024, "btc", true)
    send_crypto("btc", 0.0000000024, "test@email.com")
  end

  def get_buy_price(crypto_symbol) do
    url = "https://api.coinbase.com/v2/prices/#{String.downcase(crypto_symbol)}-eur/buy"

    case HTTPoison.get!(url) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        response = body |> Jason.decode!()
        response["data"]["amount"] |> String.to_float()

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def get_payment_methods() do
    request_path = get_request_path(@env, "payment-methods")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        response = body |> Jason.decode!()
        response["data"]

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def get_account(symbol) do
    request_path = get_request_path(@env, "accounts")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()

        res["data"]
        # |> Enum.map(fn account -> {account["currency"]["name"], account["currency"]["code"]} end)
        |> Enum.filter(fn account -> String.upcase(symbol) == account["currency"]["code"] end)
        |> hd

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def get_current_user() do
    request_path = get_request_path(@env, "user")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()
        res["data"]

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def show_transaction(symbol, tx_id) do
    account_id = get_account(symbol) |> Map.get("id")
    request_path = get_request_path(@env, "accounts/#{account_id}/transactions/#{tx_id}")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      # %HTTPoison.Response{status_code: 200, body: body} ->
      #   res = body |> Jason.decode!()
      #   res["data"]

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def update_native_currency(symbol) do
    request_path = get_request_path(@env, "user")
    url = @url <> request_path

    body =
      %{
        native_currency: String.upcase(symbol)
      }
      |> Jason.encode!()

    headers = get_headers(request_path, "PUT", body)

    case HTTPoison.put!(url, body, headers) do
      # %HTTPoison.Response{status_code: 200, body: body} ->
      #   res = body |> Jason.decode!()
      #   res["data"]

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def get_user() do
    request_path = get_request_path(@env, "users/e542da70-8eb9-5dab-9d88-32ecf7780b4e")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()
        res["data"]

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def list_accounts() do
    request_path = get_request_path(@env, "accounts")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()

        res["data"]
        |> Enum.map(fn account -> {account["currency"]["name"], account["currency"]["code"]} end)

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def list_buys(crypto_or_fiat_currency) do
    account_id = get_account(crypto_or_fiat_currency) |> Map.get("id")
    request_path = get_request_path(@env, "accounts/#{account_id}/buys")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()

        res["data"]

      # |> Enum.map(fn account -> {account["currency"]["name"], account["currency"]["code"]} end)

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def list_payment_methods() do
    request_path = get_request_path(@env, "payment-methods")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()

        res["data"]

      # |> Enum.map(fn account -> {account["currency"]["name"], account["currency"]["code"]} end)

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def buy_crypto(amount, crypto_or_fiat_currency, commit \\ true) when is_boolean(commit) do
    account_id = get_account(String.upcase(crypto_or_fiat_currency)) |> Map.get("id")
    request_path = get_request_path(@env, "accounts/#{account_id}/buys")
    url = @url <> request_path

    body =
      %{
        amount: amount,
        # total: amount,
        currency: String.upcase(crypto_or_fiat_currency),
        commit: commit,
        payment_method: "<unique payment method id>"
      }
      |> Jason.encode!()

    headers = get_headers(request_path, "POST", body)

    case HTTPoison.post!(url, body, headers) do
      # %HTTPoison.Response{status_code: 201, body: body} ->
      #   res = body |> Jason.decode!()

      #   res["data"]

      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  def send_crypto(
        symbol,
        amount,
        to \\ "test@emailcom",
        idem \\ :crypto.strong_rand_bytes(3) |> Base.encode16()
      ) do
    account_id = get_account(String.upcase(symbol)) |> Map.get("id")
    request_path = get_request_path(@env, "accounts/#{account_id}/transactions")
    url = @url <> request_path

    body =
      %{
        type: "send",
        to: to,
        amount: amount,
        # total: amount,
        currency: String.upcase(symbol),
        idem: idem,
        description: "sorry for the spam"
      }
      |> Jason.encode!()

    headers = get_headers(request_path, "POST", body)

    case HTTPoison.post!(url, body, headers) do
      %HTTPoison.Response{status_code: status_code, body: body} ->
        IO.inspect(status_code, label: "status_code")
        body |> Jason.decode!()
    end
  end

  defp get_headers(request_path, method, body) do
    timestamp = get_coinbase_server_time()

    [
      "Content-Type": "application/json",
      "CB-ACCESS-KEY": "#{@api_key}",
      "CB-ACCESS-SIGN": get_sign(request_path, method, timestamp, body),
      "CB-ACCESS-TIMESTAMP": "#{timestamp}",
      "CB-VERSION": @api_version
      #"CB-ACCESS-PASSPHRASE": @passphrase
    ]
  end

  defp get_sign(request_path, method, timestamp, body) do
    message = timestamp <> method <> request_path <> body

    :crypto.mac(:hmac, :sha256, @api_secret, message)
    |> encode(@env)
  end

  defp get_coinbase_server_time() do
    url = "https://api.coinbase.com/v2/time"

    case HTTPoison.get!(url) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        response = body |> Jason.decode!()
        response["data"]["epoch"] |> to_string()
    end
  end

  defp get_request_path(:prod, string), do: "/v2/" <> string
  defp encode(string, :prod), do: Base.encode16(string, case: :lower)
end
