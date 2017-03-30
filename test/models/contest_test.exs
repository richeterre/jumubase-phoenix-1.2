defmodule Jumubase.ContestTest do
  use Jumubase.ModelCase

  alias Jumubase.Contest

  @valid_attrs %{
    season: 54,
    round: 1,
    host_id: 1,
    start_date: %{day: 1, month: 1, year: 2017},
    end_date: %{day: 2, month: 1, year: 2017},
    signup_deadline: %{day: 15, month: 12, year: 2016},
    timetables_public: false
  }
  @invalid_attrs %{}

  describe "changeset" do
    test "with valid attributes" do
      changeset = Contest.changeset(%Contest{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Contest.changeset(%Contest{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
