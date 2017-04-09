defmodule Jumubase.ContestTest do
  use Jumubase.ModelCase
  alias Jumubase.Contest

  describe "changeset" do
    test "with valid attributes" do
      params = params_with_assocs(:contest)
      changeset = Contest.changeset(%Contest{}, params)
      assert changeset.valid?
    end

    test "without a season" do
      params = params_with_assocs(:contest, season: nil)
      changeset = Contest.changeset(%Contest{}, params)
      refute changeset.valid?
    end

    test "with an invalid season" do
      params = params_with_assocs(:contest, season: -1)
      changeset = Contest.changeset(%Contest{}, params)
      refute changeset.valid?
    end

    test "without a round" do
      params = params_with_assocs(:contest, round: nil)
      changeset = Contest.changeset(%Contest{}, params)
      refute changeset.valid?
    end

    test "with an invalid round" do
      for invalid_round <- [-1, 0, 4] do
        params = params_with_assocs(:contest, round: invalid_round)
        changeset = Contest.changeset(%Contest{}, params)
        refute changeset.valid?
      end
    end

    test "without an associated host" do
      params = params_with_assocs(:contest, host: nil)
      changeset = Contest.changeset(%Contest{}, params)
      refute changeset.valid?
    end

    test "without a start date" do
      params = params_with_assocs(:contest, start_date: nil)
      changeset = Contest.changeset(%Contest{}, params)
      refute changeset.valid?
    end

    test "without an end date" do
      params = params_with_assocs(:contest, end_date: nil)
      changeset = Contest.changeset(%Contest{}, params)
      refute changeset.valid?
    end

    test "without a signup deadline" do
      params = params_with_assocs(:contest, signup_deadline: nil)
      changeset = Contest.changeset(%Contest{}, params)
      refute changeset.valid?
    end

    test "without a timetables_public value" do
      params = params_with_assocs(:contest)
      |> Map.put(:timetables_public, nil)

      changeset = Contest.changeset(%Contest{}, params)
      refute changeset.valid?
    end
  end
end
