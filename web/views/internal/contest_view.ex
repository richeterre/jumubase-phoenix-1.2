defmodule Jumubase.Internal.ContestView do
  use Jumubase.Web, :view

  def form_rounds do
    JumuParams.rounds |> Enum.map(&({round_name(&1), &1}))
  end

  def name(contest) do
    round_name = short_round_name(contest.round)
    contest_year = JumuParams.year(contest.season)
    "#{round_name} #{contest_year}, #{contest.host.name}"
  end

  def name_with_flag(contest) do
    flag = country_code(contest) |> emoji_flag
    "#{flag} #{name(contest)}"
  end

  defp country_code(contest) do
    case contest.round do
      1 -> contest.host.country_code
      2 -> "EU"
    end
  end
end
