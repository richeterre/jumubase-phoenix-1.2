defmodule Jumubase.JumuHelpers do

  def round_name(round) do
    case round do
      1 -> "Regionalwettbewerb"
      2 -> "Landeswettbewerb"
      3 -> "Bundeswettbewerb"
    end
  end

  def short_round_name(round) do
    case round do
      1 -> "RW"
      2 -> "LW"
      3 -> "BW"
    end
  end
end
