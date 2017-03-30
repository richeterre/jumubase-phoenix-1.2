defmodule Jumubase.JumuParams do
  def get(param) do
    Application.get_env(:jumubase, :jumu_params)[param]
  end
end
