defmodule Jumubase.VenueTest do
  use Jumubase.ModelCase

  alias Jumubase.Venue

  describe "changeset" do
    test "with valid attributes" do
      params = params_with_assocs(:venue)
      changeset = Venue.changeset(%Venue{}, params)
      assert changeset.valid?
    end

    test "without a name" do
      params = params_with_assocs(:venue, name: nil)
      changeset = Venue.changeset(%Venue{}, params)
      refute changeset.valid?
    end

    test "without an associated host" do
      params = params_with_assocs(:venue, host: nil)
      changeset = Venue.changeset(%Venue{}, params)
      refute changeset.valid?
    end
  end
end
