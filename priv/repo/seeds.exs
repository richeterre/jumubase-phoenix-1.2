# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jumubase.Repo.insert!(%Jumubase.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Jumubase.Host
alias Jumubase.Repo

hosts = [
  %Host{name: "DS Helsinki", city: "Helsinki", country_code: "FI", time_zone: "Europe/Helsinki"},
  %Host{name: "DS Stockholm", city: "Stockholm", country_code: "SE", time_zone: "Europe/Stockholm"},
  %Host{name: "DS Dublin", city: "Dublin", country_code: "IE", time_zone: "Europe/Dublin"}
]
hosts |> Enum.each(fn host -> Repo.insert(host) end)
