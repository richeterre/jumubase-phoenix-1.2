defmodule Jumubase.Factory do
  use ExMachina.Ecto, repo: Jumubase.Repo
  alias Jumubase.JumuParams
  alias Jumubase.{Appearance, Category, Contest, ContestCategory, Host}
  alias Jumubase.{Instrument, Participant, Performance, User, Venue}

  @season 54

  def appearance_factory do
    %Appearance{
      performance: build(:performance),
      participant: build(:participant),
      participant_role: "soloist",
      instrument: build(:instrument),
      points: nil
    }
  end

  def category_factory do
    %Category{
      name: sequence(:name, &"Category #{&1}"),
      short_name: sequence(:short_name, &"Cat #{&1}"),
      genre: "classical",
      solo: true,
      ensemble: false
    }
  end

  def contest_factory do
    year = JumuParams.year(@season)
    %Contest{
      season: 54,
      round: 1,
      host: build(:host),
      start_date: %{day: 1, month: 1, year: year},
      end_date: %{day: 2, month: 1, year: year},
      signup_deadline: %{day: 15, month: 12, year: year - 1},
      timetables_public: false
    }
  end

  def contest_category_factory do
    %ContestCategory{
      contest: build(:contest),
      category: build(:category),
      min_age_group: "Ia",
      max_age_group: "VI",
      min_advancing_age_group: "II",
      max_advancing_age_group: "VI"
    }
  end

  def host_factory do
    %Host{
      name: sequence(:name, &"Host #{&1}"),
      city: "Jumutown",
      country_code: "DE",
      time_zone: "Europe/Berlin"
    }
  end

  def instrument_factory do
    %Instrument{
      name: sequence(:name, &"Instrument #{&1}")
    }
  end

  def participant_factory do
    %Participant{
      given_name: "Parti",
      family_name: sequence(:given_name, &"Cipant #{&1}"),
      birthdate: %{day: 1, month: 1, year: JumuParams.year(@season) - 14},
      phone: "123456789",
      email: sequence(:email, &"participant.#{&1}@example-org")
    }
  end

  def performance_factory do
    %Performance{
      contest_category: build(:contest_category),
      edit_code: sequence(:edit_code, &(&1 |> to_edit_code)),
      age_group: nil,
      stage_time: nil,
      stage_venue: nil,
      predecessor: nil,
      results_public: false
    }
  end

  def user_factory do
    %User{
      first_name: "John",
      last_name: "Doe",
      email: sequence(:email, &"user-#{&1}@example.org"),
      password: "secret",
      role: "rw-organizer"
    }
  end

  def venue_factory do
    %Venue{
      name: "Aula",
      host: build(:host)
    }
  end

  @doc """
  Inserts a contest associated with the given user via its host.
  """
  def insert_associated_contest(%User{} = user) do
    host = build(:host, users: [user])
    insert(:contest, host: host)
  end

  def insert_contest_performance(%Contest{} = contest) do
    contest_category = build(:contest_category, contest: contest)
    insert(:performance, contest_category: contest_category)
  end

  defp to_edit_code(sequence_number) do
    sequence_number |> Integer.to_string |> String.rjust(5, ?0)
  end
end
