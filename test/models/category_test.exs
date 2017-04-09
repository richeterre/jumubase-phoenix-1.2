defmodule Jumubase.CategoryTest do
  use Jumubase.ModelCase
  alias Jumubase.Category

  describe "changeset" do
    test "with valid attributes" do
      changeset = Category.changeset(%Category{}, params_for(:category))
      assert changeset.valid?
    end

    test "without a name" do
      params = params_for(:category, name: "")
      changeset = Category.changeset(%Category{}, params)
      refute changeset.valid?
    end

    test "without a short name" do
      params = params_for(:category, short_name: "")
      changeset = Category.changeset(%Category{}, params)
      refute changeset.valid?
    end

    test "with an invalid genre" do
      for invalid_genre <- [nil, '', 'xyz'] do
        params = params_for(:category, genre: invalid_genre)
        changeset = Category.changeset(%Category{}, params)
        refute changeset.valid?
      end
    end

    test "with neither solo nor ensemble checked" do
      params = params_for(:category, %{solo: false, ensemble: false})
      changeset = Category.changeset(%Category{}, params)
      refute changeset.valid?
    end
  end

  test "list_order/1" do
    insert(:category, %{name: "g", genre: "popular", solo: true, ensemble: false})
    insert(:category, %{name: "i", genre: "popular", solo: false, ensemble: true})
    insert(:category, %{name: "h", genre: "popular", solo: false, ensemble: true})
    insert(:category, %{name: "f", genre: "popular", solo: true, ensemble: false})
    insert(:category, %{name: "b", genre: "classical", solo: true, ensemble: false})
    insert(:category, %{name: "d", genre: "classical", solo: false, ensemble: true})
    insert(:category, %{name: "c", genre: "classical", solo: false, ensemble: true})
    insert(:category, %{name: "a", genre: "classical", solo: true, ensemble: false})
    insert(:category, %{name: "e", genre: "kimu", solo: true, ensemble: true})

    query = Category |> Category.list_order
    query = from c in query, select: c.name
    assert Repo.all(query) == ~w(a b c d e f g h i)
  end
end
