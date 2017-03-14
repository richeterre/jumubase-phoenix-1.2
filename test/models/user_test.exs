defmodule Jumubase.UserTest do
  use Jumubase.ModelCase

  alias Jumubase.User

  @valid_attrs %{
    first_name: "A", last_name: "B", email: "email", password: "secret"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
