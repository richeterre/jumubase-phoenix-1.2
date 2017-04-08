defmodule Jumubase.Factory do
  alias Jumubase.{Host, User}

  def factory(:user, role) do
    %User{
      first_name: "Rieke",
      last_name: "Regionalwetter",
      email: "rw-org@example.org",
      password: "secret",
      role: role
    }
  end

  def factory(:host) do
    %Host{
      name: "DS Helsinki",
      city: "Helsinki",
      country_code: "FI",
      time_zone: "Europe/Helsinki"
    }
  end
end
