defmodule Jumubase.Internal.CategoryView do
  use Jumubase.Web, :view

  def genre_name(genre) do
    case genre do
      "kimu" -> "Kimu"
      "classical" -> "Klassik"
      "popular" -> "Pop"
    end
  end

  def form_genres() do
    JumuParams.genres |> Enum.map(&({genre_name(&1), &1}))
  end
end
