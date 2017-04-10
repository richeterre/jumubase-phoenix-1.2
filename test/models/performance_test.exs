defmodule Jumubase.PerformanceTest do
  use Jumubase.ModelCase
  alias Jumubase.Performance

  describe "changeset" do
    test "with valid attributes" do
      params = params_with_assocs(:performance)
      changeset = Performance.changeset(%Performance{}, params)
      assert changeset.valid?
    end

    test "without an associated contest category" do
      params = params_with_assocs(:performance, contest_category: nil)
      changeset = Performance.changeset(%Performance{}, params)
      refute changeset.valid?
    end

    test "without an edit code" do
      params = params_with_assocs(:performance, edit_code: nil)
      changeset = Performance.changeset(%Performance{}, params)
      refute changeset.valid?
    end

    test "with an invalid age group" do
      for invalid_age_group <- ["ii", "Ic", "VIII"] do
        params = params_with_assocs(:performance, age_group: invalid_age_group)
        changeset = Performance.changeset(%Performance{}, params)
        refute changeset.valid?
      end
    end

    test "without a results_public value" do
      params = params_with_assocs(:performance)
      |> Map.put(:results_public, nil)
      changeset = Performance.changeset(%Performance{}, params)
      refute changeset.valid?
    end
  end
end
