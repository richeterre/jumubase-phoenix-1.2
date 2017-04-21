defmodule Jumubase.ContestView do
  use Jumubase.Web, :view
  import Jumubase.Internal.ContestView, only: [name: 1]

  def render("index.json", %{contests: contests}) do
    Enum.map(contests, &contest_json/1)
  end

  defp contest_json(contest) do
    time_zone = contest.host.time_zone

    %{
      id: contest.id,
      name: name(contest),
      host_country: contest.host.country_code,
      time_zone: contest.host.time_zone,
      start_date: to_datetime(contest.start_date, time_zone),
      end_date: to_datetime(contest.end_date, time_zone),
      contest_categories: Enum.map(contest.contest_categories, &contest_category_json/1),
      venues: Enum.map(contest.venues, &venue_json/1),
    }
  end

  defp venue_json(venue) do
    %{
      id: Integer.to_string(venue.id),
      name: venue.name
    }
  end

  defp contest_category_json(contest_category) do
    %{
      id: Integer.to_string(contest_category.id),
      name: contest_category.category.name
    }
  end

  defp to_datetime(date, time_zone) do
    Timex.to_datetime(date, time_zone)
  end
end
