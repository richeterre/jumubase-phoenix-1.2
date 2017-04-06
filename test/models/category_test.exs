defmodule Jumubase.CategoryTest do
  use Jumubase.ModelCase

  alias Jumubase.Category

  @valid_attrs %{genre: "some content", name: "some content", short_name: "some content", solo: true, ensemble: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end
end
