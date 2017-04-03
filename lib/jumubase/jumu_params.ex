defmodule Jumubase.JumuParams do
  @doc """
  Returns the year for a given season.
  """
  def year(season) do
    1963 + season
  end

  @doc """
  Returns the available competition rounds.
  """
  def rounds do
    1..3
  end

  @doc """
  Returns all possible user roles.
  """
  def roles do
    [
      "rw-organizer", # a "regular" member organizing RW contests
      "lw-organizer", # someone organizing LW (and often RW) contests
      "inspector", # an outside official looking for statistics
      "admin"
    ]
  end
end
