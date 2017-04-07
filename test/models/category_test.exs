defmodule Jumubase.CategoryTest do
  use Jumubase.ModelCase

  alias Jumubase.Category

  @valid_attrs %{
    name: "Klavier solo",
    short_name: "Klavier",
    genre: "classical",
    solo: true,
    ensemble: false
  }

  describe "changeset" do
    test "with valid attributes" do
      changeset = Category.changeset(%Category{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with an invalid name" do
      attrs = Map.put(@valid_attrs, :name, "")
      changeset = Category.changeset(%Category{}, attrs)
      refute changeset.valid?
    end

    test "with an invalid short name" do
      attrs = Map.put(@valid_attrs, :short_name, "")
      changeset = Category.changeset(%Category{}, attrs)
      refute changeset.valid?
    end

    test "with an invalid genre" do
      for invalid_genre <- [nil, '', 'xyz'] do
        attrs = Map.put(@valid_attrs, :genre, invalid_genre)
        changeset = Category.changeset(%Category{}, attrs)
        refute changeset.valid?
      end
    end

    test "with neither solo nor ensemble checked" do
      attrs = Map.merge(@valid_attrs, %{solo: false, ensemble: false})
      changeset = Category.changeset(%Category{}, attrs)
      refute changeset.valid?
    end
  end
end
