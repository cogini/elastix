defmodule Elastix.AliasTest do
  use ExUnit.Case
  alias Elastix.Alias
  alias Elastix.Index

  @test_url Elastix.config(:test_url)
  @test_index Elastix.config(:test_index)

  setup do
    Index.delete(@test_url, @test_index)

    :ok
  end

  test "aliases actions on existing index should respond with 200" do
    assert {:ok, %{status_code: 200}} = Index.create(@test_url, @test_index, %{})

    {:ok, response} = Alias.post(@test_url, [
      %{add: %{index: @test_index, alias: "alias1"}},
      %{remove: %{index: @test_index, alias: "alias1"}}
    ])
    assert response.status_code == 200
  end

  test "remove unkown alias on existing index should respond with 404" do
    assert {:ok, %{status_code: 200}} = Index.create(@test_url, @test_index, %{})

    {:ok, response} = Alias.post(@test_url, [%{remove: %{index: @test_index, alias: "alias1"}}])
    assert response.status_code == 404
  end

  test "alias actions on unknown index should respond with 404" do
    {:ok, response} = Alias.post(@test_url, [%{add: %{index: @test_index, alias: "alias1"}}])
    assert response.status_code == 404
  end
end
