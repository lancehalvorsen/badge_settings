defmodule BadgeSettings.SettingController do
  use BadgeSettings.Web, :controller

  alias BadgeSettings.Setting

  plug :authenticate
  plug :set_login_link

  @setting_file Application.get_env(:badge_settings, :nerves_settings).settings_file
  @device_name Application.get_env(:badge_settings, :nerves_settings).device_name

  def index(conn, _params) do
    redirect(conn, to: setting_path(conn, :show, %Setting{id: "show"}))
  end

  def new(conn, _params) do
    setting = fetch_setting()
    render(conn, "new.html", changeset: Setting.changeset(setting))
  end

  def create(conn, %{"setting" => setting_params}) do
    changeset = Setting.changeset(%Setting{}, setting_params)
    encoded = :erlang.term_to_binary(changeset.changes)


    case changeset.valid? do
      true ->
        File.write!(@setting_file, encoded)
        conn
        |> put_flash(:info, "Settings created successfully.")
        |> redirect(to: setting_path(conn, :show, %Setting{id: "show"}))
      false ->
        changeset = %{changeset | action: :update}
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    setting = fetch_setting()
    render(conn, "show.html", setting: setting)
  end

  defp fetch_setting() do
    case File.read(@setting_file) do
      {:error, :enoent} -> %Setting{id: "show"}
      {:ok, ""} -> %Setting{id: "show"}
      {:ok, contents} ->
        unencoded = :erlang.binary_to_term(contents)
        Map.merge(%Setting{id: "show"}, unencoded)
    end
  end

  defp authenticate(conn, _opts) do
    case get_session(conn, :device_name) do
      @device_name ->
        conn
      _ ->
        conn
        |> put_flash(:error, "You need to log in first.")
        |> redirect(to: session_path(conn, :new))
        |> halt()
    end
  end

  defp set_login_link(conn, _opts) do
    assign(conn, :login_link, true)
  end
end
