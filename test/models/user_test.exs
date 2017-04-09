defmodule Jumubase.UserTest do
  use Jumubase.ModelCase
  alias Jumubase.User

  describe "changeset" do
    test "with valid attributes" do
      params = params_with_assocs(:user)
      changeset = User.changeset(%User{}, params)
      assert changeset.valid?
    end

    test "without a first name" do
      params = params_with_assocs(:user, first_name: "")
      changeset = User.changeset(%User{}, params)
      refute changeset.valid?
    end

    test "without a last name" do
      params = params_with_assocs(:user, last_name: "")
      changeset = User.changeset(%User{}, params)
      refute changeset.valid?
    end

    test "without an email" do
      params = params_with_assocs(:user, email: "")
      changeset = User.changeset(%User{}, params)
      refute changeset.valid?
    end

    test "with an invalid role" do
      for invalid_role <- [nil, "", "xyz"] do
        params = params_with_assocs(:user, role: invalid_role)
        changeset = User.changeset(%User{}, params)
        refute changeset.valid?
      end
    end
  end

  describe "registration_changeset" do
    test "with valid attributes" do
      params = params_with_assocs(:user)
      changeset = User.registration_changeset(%User{}, params)
      assert changeset.valid?
    end

    test "without a password" do
      params = params_with_assocs(:user, password: nil)
      changeset = User.registration_changeset(%User{}, params)
      refute changeset.valid?
    end

    test "with too short password" do
      params = params_with_assocs(:user, password: "12345")
      changeset = User.registration_changeset(%User{}, params)
      assert {:password, {"should be at least %{count} character(s)",
        count: 6, validation: :length, min: 6}}
        in changeset.errors
    end

    test "password hashing" do
      params = params_with_assocs(:user)
      changeset = User.registration_changeset(%User{}, params)
      %{password: pass, password_hash: pass_hash} = changeset.changes

      assert changeset.valid?
      assert pass_hash
      assert Comeonin.Bcrypt.checkpw(pass, pass_hash)
    end
  end
end
