defmodule Jumubase.ContestController do
  use Jumubase.Web, :controller
  alias Jumubase.Contest

  def index(conn, _params) do
    contests = Repo.all(from c in Contest,
      order_by: [desc: c.start_date],
      preload: [:host, :venues, contest_categories: :category]
    )

    conn
    |> assign(:contests, contests)
    |> render("index.json")
  end
end
