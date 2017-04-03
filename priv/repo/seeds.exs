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

alias Jumubase.JumuParams
alias Jumubase.Repo
alias Jumubase.User
alias Jumubase.Host
alias Jumubase.Contest

Repo.transaction fn ->
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
  Repo.insert!(lw_organizer_changeset)

  rw_organizer_changeset = User.registration_changeset(%User{}, %{
    first_name: "Rieke",
    last_name: "Regionalwetter",
    email: "rw-org@example.org",
    password: "secret",
    role: "rw-organizer"
  })
  Repo.insert!(rw_organizer_changeset)

  inspector_changeset = User.registration_changeset(%User{}, %{
    first_name: "Ivo",
    last_name: "Inspektor",
    email: "inspektor@example.org",
    password: "secret",
    role: "inspector"
  })
  Repo.insert!(inspector_changeset)

  # Create demo hosts

  host1 = Repo.insert!(%Host{name: "DS Helsinki", city: "Helsinki", country_code: "FI", time_zone: "Europe/Helsinki"})
  host2 = Repo.insert!(%Host{name: "DS Stockholm", city: "Stockholm", country_code: "SE", time_zone: "Europe/Stockholm"})
  host3 = Repo.insert!(%Host{name: "DS Dublin", city: "Dublin", country_code: "IE", time_zone: "Europe/Dublin"})

  # Create demo contests

  season = 54
  year = JumuParams.year(season)
  contest_attrs = %{
    season: season,
    round: 1,
    start_date: %{day: 1, month: 1, year: year},
    end_date: %{day: 2, month: 1, year: year},
    signup_deadline: %{day: 15, month: 12, year: year - 1},
    timetables_public: false
  }

  contests = [
    Contest.changeset(%Contest{}, Map.put(contest_attrs, :host_id, host1.id)),
    Contest.changeset(%Contest{}, Map.put(contest_attrs, :host_id, host2.id)),
    Contest.changeset(%Contest{}, Map.put(contest_attrs, :host_id, host3.id)),
    Contest.changeset(%Contest{}, Map.merge(contest_attrs, %{
      host_id: host1.id,
      round: 2,
      start_date: %{day: 15, month: 3, year: year},
      end_date: %{day: 17, month: 3, year: year},
      signup_deadline: %{day: 28, month: 2, year: year},
    }))
  ]
  contests |> Enum.each(&Repo.insert!(&1))
end
