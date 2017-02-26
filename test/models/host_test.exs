defmodule Jumubase.HostTest do
  use Jumubase.ModelCase

  alias Jumubase.Host

  @valid_attrs %{
    city: "Helsinki",
    country_code: "fi",
    name: "DS Helsinki",
    time_zone: "Europe/Helsinki"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Host.changeset(%Host{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Host.changeset(%Host{}, @invalid_attrs)
    refute changeset.valid?
  end
end
