defmodule Jumubase.AppearanceTest do
  use Jumubase.ModelCase

  alias Jumubase.Appearance

  describe "changeset" do
    test "with valid attributes" do
      params = params_with_assocs(:appearance)
      changeset = Appearance.changeset(%Appearance{}, params)
      assert changeset.valid?
    end

    test "without an associated performance" do
      params = params_with_assocs(:appearance, performance: nil)
      changeset = Appearance.changeset(%Appearance{}, params)
      refute changeset.valid?
    end

    test "without an associated participant" do
      params = params_with_assocs(:appearance, participant: nil)
      changeset = Appearance.changeset(%Appearance{}, params)
      refute changeset.valid?
    end

    test "without a participant role" do
      params = params_with_assocs(:appearance, participant_role: nil)
      changeset = Appearance.changeset(%Appearance{}, params)
      refute changeset.valid?
    end

    test "with an invalid participant role" do
      for invalid_role <- ["solist", "acc", "ensemble"] do
        params = params_with_assocs(:appearance, points: invalid_role)
        changeset = Appearance.changeset(%Appearance{}, params)
        refute changeset.valid?
      end
    end

    test "without an associated instrument" do
      params = params_with_assocs(:appearance, instrument: nil)
      changeset = Appearance.changeset(%Appearance{}, params)
      refute changeset.valid?
    end

    test "with invalid points" do
      for invalid_points <- [-1, 26, 22.5] do
        params = params_with_assocs(:appearance, points: invalid_points)
        changeset = Appearance.changeset(%Appearance{}, params)
        refute changeset.valid?
      end
    end
  end
end
