defmodule Jumubase.ErrorViewTest do
  use Jumubase.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(Jumubase.ErrorView, "404.html", []) ==
           "Seite nicht gefunden"
  end

  test "render 500.html" do
    assert render_to_string(Jumubase.ErrorView, "500.html", []) ==
           "Interner Serverfehler"
  end

  test "render any other" do
    assert render_to_string(Jumubase.ErrorView, "505.html", []) ==
           "Interner Serverfehler"
  end
end
