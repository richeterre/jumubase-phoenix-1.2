defmodule Jumubase.UserTest do
  use Jumubase.ModelCase

  alias Jumubase.User

  @valid_attrs %{
    first_name: "A", last_name: "B", email: "email", role: "rw-organizer"}
  @invalid_attrs %{}

  describe "changeset" do
    test "with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "registration_changeset" do
    test "with too short password" do
      attrs = Map.put(@valid_attrs, :password, "12345")
      changeset = User.registration_changeset(%User{}, attrs)
      assert {:password, {"should be at least %{count} character(s)",
        count: 6, validation: :length, min: 6}}
        in changeset.errors
    end

    test "with long enough password" do
      attrs = Map.put(@valid_attrs, :password, "123456")
      changeset = User.registration_changeset(%User{}, attrs)
      assert changeset.valid?
    end

    test "password hashing" do
      attrs = Map.put(@valid_attrs, :password, "123456")
      changeset = User.registration_changeset(%User{}, attrs)
      %{password: pass, password_hash: pass_hash} = changeset.changes

      assert changeset.valid?
      assert pass_hash
      assert Comeonin.Bcrypt.checkpw(pass, pass_hash)
    end
  end
end
