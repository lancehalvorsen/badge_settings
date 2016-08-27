defmodule BadgeSettings.SessionController do
  use BadgeSettings.Web, :controller

  alias BadgeSettings.Session

  @password Application.get_env(:badge_settings, :nerves_settings).application_password
  @device_name Application.get_env(:badge_settings, :nerves_settings).device_name

  plug :set_login_link

  def index(conn, _params) do
    redirect(conn, to: session_path(conn, :new))
  end

  def new(conn, _params) do
    changeset = Session.new_changeset(%Session{})
    render(conn, "new.html", device_name: @device_name, changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    session_params = Map.put_new(session_params, "password_confirmation", @password)
    changeset = Session.create_changeset(%Session{}, session_params)

    case changeset.valid? do
      true ->
        conn
        |> put_session(:device_name, @device_name)
        |> configure_session(renew: true)
        |> redirect(to: setting_path(conn, :new))
      false ->
        render(conn, "new.html", device_name: @device_name, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session
    |> configure_session(drop: true)
    |> redirect(to: session_path(conn, :new))
  end

  defp set_login_link(conn, _opts) do
    assign(conn, :login_link, false)
  end
end
