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

import Jumubase.Factory
alias Ecto.Changeset
alias Jumubase.JumuParams
alias Jumubase.Repo
alias Jumubase.{Category, Host, User}

Repo.transaction fn ->
  # Create demo hosts

  host1 = Repo.insert!(%Host{name: "DS Helsinki", city: "Helsinki", country_code: "FI", time_zone: "Europe/Helsinki"})
  host2 = Repo.insert!(%Host{name: "DS Stockholm", city: "Stockholm", country_code: "SE", time_zone: "Europe/Stockholm"})
  host3 = Repo.insert!(%Host{name: "DS Dublin", city: "Dublin", country_code: "IE", time_zone: "Europe/Dublin"})

  # Create demo users

  admin_changeset = User.registration_changeset(%User{}, %{
    first_name: "Anna",
    last_name: "Admin",
    email: "admin@example.org",
    password: "secret",
    role: "admin"
  })
  Repo.insert!(admin_changeset)

  lw_organizer_changeset = User.registration_changeset(%User{}, %{
    first_name: "Lukas",
    last_name: "Landeswetter",
    email: "lw-org@example.org",
    password: "secret",
    role: "lw-organizer"
  })
  |> Changeset.put_assoc(:hosts, [host2])
  Repo.insert!(lw_organizer_changeset)

  rw_organizer_changeset = User.registration_changeset(%User{}, %{
    first_name: "Rieke",
    last_name: "Regionalwetter",
    email: "rw-org@example.org",
    password: "secret",
    role: "rw-organizer"
  })
  |> Changeset.put_assoc(:hosts, [host3])
  Repo.insert!(rw_organizer_changeset)

  inspector_changeset = User.registration_changeset(%User{}, %{
    first_name: "Ivo",
    last_name: "Inspektor",
    email: "inspektor@example.org",
    password: "secret",
    role: "inspector"
  })
  Repo.insert!(inspector_changeset)

  # Create demo contests

  season = 54
  year = JumuParams.year(season)

  contest1 = insert(:contest, host: host1)
  contest2 = insert(:contest, host: host2)
  contest3 = insert(:contest, host: host3)
  contest4 = insert(:contest, %{
    host: host1,
    round: 2,
    start_date: %{day: 15, month: 3, year: year},
    end_date: %{day: 17, month: 3, year: year},
    signup_deadline: %{day: 28, month: 2, year: year}
  })

  # Create demo categories

  kimu = Repo.insert!(%Category{name: "\"Kinder musizieren\"", short_name: "Kimu", genre: "kimu", solo: true, ensemble: true})
  piano = Repo.insert!(%Category{name: "Klavier solo", short_name: "Klavier", genre: "classical", solo: true, ensemble: false})
  wind_ens = Repo.insert!(%Category{name: "Bläser-Ensemble", short_name: "BläserEns", genre: "classical", solo: false, ensemble: true})
  pop_drums = Repo.insert!(%Category{name: "Drumset (Pop) solo", short_name: "PopDrums", genre: "popular", solo: true, ensemble: false})
  pop_vocal_ens = Repo.insert!(%Category{name: "Vokal-Ensemble (Pop)", short_name: "PopVokalEns", genre: "popular", solo: false, ensemble: true})

  # Create demo contest categories

  for rw_contest <- [contest1, contest2, contest3] do
    insert(:contest_category, %{
      contest: rw_contest,
      category: kimu,
      min_age_group: "Ia",
      max_age_group: "II",
      min_advancing_age_group: nil,
      max_advancing_age_group: nil
    })
    insert(:contest_category, %{
      contest: rw_contest,
      category: piano,
      min_age_group: "Ia",
      max_age_group: "VI",
      min_advancing_age_group: "II",
      max_advancing_age_group: "VI"
    })
    insert(:contest_category, %{
      contest: rw_contest,
      category: wind_ens,
      min_age_group: "Ia",
      max_age_group: "VI",
      min_advancing_age_group: "II",
      max_advancing_age_group: "VI"
    })
    insert(:contest_category, %{
      contest: rw_contest,
      category: pop_drums,
      min_age_group: "Ia",
      max_age_group: "VI",
      min_advancing_age_group: "II",
      max_advancing_age_group: "VI"
    })
    insert(:contest_category, %{
      contest: rw_contest,
      category: pop_vocal_ens,
      min_age_group: "Ia",
      max_age_group: "VII",
      min_advancing_age_group: "III",
      max_advancing_age_group: "VII"
    })
  end

  insert(:contest_category, %{
    contest: contest4,
    category: piano,
    min_age_group: "II",
    max_age_group: "VI",
    min_advancing_age_group: "III",
    max_advancing_age_group: "VI"
  })
  insert(:contest_category, %{
    contest: contest4,
    category: wind_ens,
    min_age_group: "II",
    max_age_group: "VI",
    min_advancing_age_group: "III",
    max_advancing_age_group: "VI"
  })
  insert(:contest_category, %{
    contest: contest4,
    category: pop_drums,
    min_age_group: "II",
    max_age_group: "VI",
    min_advancing_age_group: "III",
    max_advancing_age_group: "VI"
  })
  insert(:contest_category, %{
    contest: contest4,
    category: pop_vocal_ens,
    min_age_group: "III",
    max_age_group: "VII",
    min_advancing_age_group: nil,
    max_advancing_age_group: nil
  })
end
