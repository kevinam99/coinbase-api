defmodule CoinbaseApiPro do
  @moduledoc """
  Documentation for `CoinbaseApiSandbox`.
  """
  # coinbase pro sandbox
  @api_key Application.fetch_env!(:coinbase_api, :sandbox_api_key)
  @api_secret Application.fetch_env!(:coinbase_api, :sandbox_api_secret)
              |> Base.decode64!()

  @url "https://api.exchange.coinbase.com"
  @env :sandbox

  @api_version "2019-11-15"
  @passphrase Application.fetch_env!(:coinbase_api, :passphrase)

  def get_account(symbol) do
    request_path = get_request_path(@env, "accounts")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()

        res
        # |> Enum.map(fn account -> {account["currency"]["name"], account["currency"]["code"]} end)
        |> Enum.filter(fn account -> account["currency"] == String.upcase(symbol) end)

      # |> hd

      %HTTPoison.Response{body: body} ->
        body |> Jason.decode!()
    end
  end

  def get_single_order(order_id) do
    request_path = get_request_path(@env, "orders/#{order_id}")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()

        res

      # |> Enum.map(fn account -> {account["currency"]["name"], account["currency"]["code"]} end)
      # |> Enum.filter(fn account -> account["currency"] == String.upcase(symbol) end)
      # |> hd

      %HTTPoison.Response{body: body} ->
        body |> Jason.decode!()
    end
  end

  def get_convertible_currencies() do
    request_path = get_request_path(@env, "currencies")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        res = body |> Jason.decode!()

        res
        # |> Enum.map(fn account -> {account["currency"]["name"], account["currency"]["code"]} end)
        |> Enum.filter(fn account -> account["convertible_to"] |> Enum.count() > 0 end)

      # |> hd

      %HTTPoison.Response{body: body} ->
        body |> Jason.decode!()
    end
  end

  def market_order(size, product_id) do
    # account_id = CoinbaseApi.get_account(String.upcase(symbol)) |> Map.get("id")
    request_path = get_request_path(@env, "orders")
    url = @url <> request_path

    body =
      %{
        # required
        product_id: product_id,
        funds: size,
        type: "market",
        side: "buy",
        # optional
        client_oid: :crypto.strong_rand_bytes(6) |> Base.encode16()
      }
      |> Jason.encode!()

    headers = get_headers(request_path, "POST", body)

    case HTTPoison.post!(url, body, headers) do
      %HTTPoison.Response{body: body} -> body |> Jason.decode!()
    end
  end

  def convert(from, to, amount) do
    # account_id = CoinbaseApi.get_account(String.upcase(symbol)) |> Map.get("id")
    request_path = get_request_path(@env, "conversions")
    url = @url <> request_path

    body =
      %{
        from: from,
        to: to,
        amount: amount
      }
      |> Jason.encode!()

    headers = get_headers(request_path, "POST", body)

    case HTTPoison.post!(url, body, headers) do
      %HTTPoison.Response{body: body} -> body |> Jason.decode!()
    end
  end

  def deposit_from_cb(symbol, amount) do
    account_id = CoinbaseApi.get_account(String.upcase(symbol)) |> Map.get("id")
    request_path = get_request_path(@env, "deposits/coinbase-account")
    url = @url <> request_path

    body =
      %{
        coinbase_account_id: account_id,
        amount: amount,
        currency: String.upcase(symbol)
      }
      |> Jason.encode!()

    headers = get_headers(request_path, "POST", body)

    case HTTPoison.post!(url, body, headers) do
      %HTTPoison.Response{body: body} -> body |> Jason.decode!()
    end
  end

  def withdraw_to_cb(symbol, amount) do
    account_id = CoinbaseApi.get_account(String.upcase(symbol)) |> Map.get("id")
    request_path = get_request_path(@env, "withdrawals/coinbase-account")
    url = @url <> request_path

    body =
      %{
        coinbase_account_id: account_id,
        amount: amount,
        currency: String.upcase(symbol)
      }
      |> Jason.encode!()

    headers = get_headers(request_path, "POST", body)

    case HTTPoison.post!(url, body, headers) do
      %HTTPoison.Response{body: body} -> body |> Jason.decode!()
    end
  end

  def get_current_user() do
    request_path = get_request_path(@env, "coinbase-accounts")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body |> Jason.decode!()

      %HTTPoison.Response{body: body} ->
        body |> Jason.decode!()
    end
  end

  def get_user() do
    request_path = get_request_path(@env, "users/e542da70-8eb9-5dab-9d88-32ecf7780b4e")
    url = @url <> request_path

    headers = get_headers(request_path, "GET", "")

    case HTTPoison.get!(url, headers) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body |> Jason.decode!()

      %HTTPoison.Response{body: body} ->
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

        res
        |> Enum.map(fn account -> {account["currency"], account["balance"]} end)

      %HTTPoison.Response{body: body} ->
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

        res

      # |> Enum.map(fn account -> {account["currency"], account["balance"]} end)

      %HTTPoison.Response{body: body} ->
        body |> Jason.decode!()
    end
  end

  def send_crypto(symbol) do
    account_id = get_account(symbol) |> Map.get("id")
    request_path = get_request_path(@env, "accounts/#{account_id}/transactions")
    url = @url <> request_path

    body =
      %{
        type: "send",
        to: "0x89811603161fCFaF010f1b9442ac470a81e54D8A",
        amount: "7",
        currency: "BAT",
        idem: "9316dd16-0c05",
        description: "Exchange points for crypto"
      }
      |> Jason.encode!()

    headers = get_headers(request_path, "POST", body)

    case HTTPoison.post!(url, body, headers) do
      %HTTPoison.Response{body: body} -> body |> Jason.decode!()
    end
  end

  defp get_headers(request_path, method, body) do
    timestamp = get_coinbase_server_time()

    [
      "Content-Type": "application/json",
      "CB-ACCESS-KEY": "#{@api_key}",
      "CB-ACCESS-SIGN": get_sign(request_path, method, timestamp, body),
      "CB-ACCESS-TIMESTAMP": "#{timestamp}",
      "CB-VERSION": @api_version,
      "CB-ACCESS-PASSPHRASE": @passphrase
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

  defp get_request_path(:sandbox, string), do: "/" <> string
  defp encode(string, :sandbox), do: Base.encode64(string)
end
