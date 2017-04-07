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

  test "list_order/1" do
    Repo.insert!(%Category{name: "g", genre: "popular", solo: true, ensemble: false})
    Repo.insert!(%Category{name: "i", genre: "popular", solo: false, ensemble: true})
    Repo.insert!(%Category{name: "h", genre: "popular", solo: false, ensemble: true})
    Repo.insert!(%Category{name: "f", genre: "popular", solo: true, ensemble: false})
    Repo.insert!(%Category{name: "b", genre: "classical", solo: true, ensemble: false})
    Repo.insert!(%Category{name: "d", genre: "classical", solo: false, ensemble: true})
    Repo.insert!(%Category{name: "c", genre: "classical", solo: false, ensemble: true})
    Repo.insert!(%Category{name: "a", genre: "classical", solo: true, ensemble: false})
    Repo.insert!(%Category{name: "e", genre: "kimu", solo: true, ensemble: true})

    query = Category |> Category.list_order
    query = from c in query, select: c.name
    assert Repo.all(query) == ~w(a b c d e f g h i)
  end
end
