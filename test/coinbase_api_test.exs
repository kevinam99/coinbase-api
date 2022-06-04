defmodule CoinbaseApiTest do
  use ExUnit.Case, async: true
  doctest CoinbaseApi

  describe "prod tests" do
    test "get_account/0 returns a specific account" do
      response = CoinbaseApi.get_account()

      assert %{
               "name" => _name,
               "balance" => _balance
             } = response
    end

    test "get_current_user/0 shows the user" do
      response = CoinbaseApi.get_current_user()

      assert %{
               "email" => _email,
               "avatar_url" => _avatar
             } = response
    end

    test "get_user/0 shows the specific user with that user_id" do
      response = CoinbaseApi.get_user()

      assert %{
               "email" => _email,
               "id" => _id,
               "name" => _name
             } = response
    end

    test "list_accounts/0 gets a list of accounts the user has access to" do
      response = CoinbaseApi.list_accounts()
      assert Enum.count(response) > 0
    end

    test "send_crypto/0 sends the specified crypto to the valid addresss" do
      response = CoinbaseApi.send_crypto()

      assert %{
               "id" => _id,
               "type" => "send",
               "status" => _status
             } = response
    end
  end

  describe "sandbox tests" do
    test "get_account/0 returns a specific account" do
      response = CoinbaseApiSandbox.get_account()

      assert %{
               "available" => _available,
               "balance" => _balance
             } = response
    end

    test "get_current_user/0 shows the user" do
      response = CoinbaseApiSandbox.get_current_user()

      assert %{
               "email" => _email,
               "avatar" => _avatar
             } = response
    end

    test "get_user/0 shows the specific user with that user_id" do
      response = CoinbaseApiSandbox.get_user()

      assert %{
               "email" => _email,
               "id" => _id,
               "name" => _name
             } = response
    end

    test "list_accounts/0 gets a list of accounts the user has access to" do
      response = CoinbaseApiSandbox.list_accounts()
      assert Enum.count(response) > 1
    end

    test "send_crypto/0 sends the specified crypto to the valid addresss" do
      response = CoinbaseApiSandbox.send_crypto()

      assert %{
               "id" => _id,
               "type" => "send",
               "status" => _status
             } = response
    end
  end
end
