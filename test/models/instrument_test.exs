defmodule Jumubase.InstrumentTest do
  use Jumubase.ModelCase
  alias Jumubase.Instrument

  describe "changeset" do
    test "with valid attributes" do
      params = params_for(:instrument)
      changeset = Instrument.changeset(%Instrument{}, params)
      assert changeset.valid?
    end

    test "without a name" do
      params = params_for(:instrument, name: nil)
      changeset = Instrument.changeset(%Instrument{}, params)
      refute changeset.valid?
    end
  end
end
