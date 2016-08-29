defmodule BadgeSettings.SettingControllerTest do
  use BadgeSettings.ConnCase

  alias BadgeSettings.Setting

  @valid_attrs %{handle: "@some_content", hashtag: "#some_content", password: "some_content", ssid: "some_content"}
  @invalid_attrs %{}
  @setting_file Application.get_env(:badge_settings, :nerves_settings).settings_file
  @device_name Application.get_env(:badge_settings, :nerves_settings).device_name

  setup do
    on_exit fn ->
      File.rm(@setting_file)
    end
  end

  describe ".index when not authenticated" do
    test "redirects to the session new action", %{conn: conn} do
      conn = get conn, setting_path(conn, :index)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "sets an error message", %{conn: conn} do
      conn = get conn, setting_path(conn, :index)
      assert get_flash(conn, :error) =~ "You need to log in first."
    end
  end

  describe ".index" do
    test "with the proper session cookie, redirects to the show action", %{conn: conn} do
      conn = authenticated_conn(conn)
      conn = get conn, setting_path(conn, :index)
      assert redirected_to(conn) == setting_path(conn, :show, %Setting{id: "show"})
    end
  end

  describe ".show when not authenticated" do
    test "redirects to the session new action", %{conn: conn} do
      conn = get conn, setting_path(conn, :show, %Setting{id: "show"})
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "sets an error message", %{conn: conn} do
      conn = get conn, setting_path(conn, :show, %Setting{id: "show"})
      assert get_flash(conn, :error) =~ "You need to log in first."
    end
  end

  describe ".show" do
    test "renders form for new resources", %{conn: conn} do
      conn = authenticated_conn(conn)
      conn = get conn, setting_path(conn, :new)
      assert html_response(conn, 200) =~ "Change Your Device Settings"
    end

    test "handles a missing file", %{conn: conn} do
      conn = authenticated_conn(conn)
      File.rm(@setting_file)
      conn = get conn, setting_path(conn, :new)
      assert html_response(conn, 200) =~ "Change Your Device Settings"
    end

    test "handles an empty file", %{conn: conn} do
      conn = authenticated_conn(conn)
      File.rm(@setting_file)
      File.write("nerves_settings.txt", "")
      conn = get conn, setting_path(conn, :new)
      assert html_response(conn, 200) =~ "Change Your Device Settings"
    end

    test "handles a file with data", %{conn: conn} do
      conn = authenticated_conn(conn)
      encoded = :erlang.term_to_binary(%{ssid: "derp"})
      File.write(@setting_file, encoded)
      conn = get conn, setting_path(conn, :new)
      assert html_response(conn, 200) =~ "Change Your Device Settings"
    end
  end

  describe ".create when not authenticated" do
    test "redirects to the session new action", %{conn: conn} do
      conn = post conn, setting_path(conn, :create), setting: @valid_attrs
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "sets an error message", %{conn: conn} do
      conn = post conn, setting_path(conn, :create), setting: @valid_attrs
      assert get_flash(conn, :error) =~ "You need to log in first."
    end
  end

  describe ".create" do
    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = authenticated_conn(conn)
      conn = post conn, setting_path(conn, :create), setting: @valid_attrs
      assert redirected_to(conn) == setting_path(conn, :show, %Setting{id: "show"})
    end

    test "validates the parameters", %{conn: conn} do
      conn = authenticated_conn(conn)
      File.rm(@setting_file)
      conn = post conn, setting_path(conn, :create), setting: %{}
      assert html_response(conn, 200) =~ "Oops, something went wrong!"
    end

    test "writes the file to disc", %{conn: conn} do
      conn = authenticated_conn(conn)
      File.rm(@setting_file)
      params = %{ssid: "silly", password: "derptastic", handle: "@dweezil", hashtag: "#myelixirstatus"}
      post conn, setting_path(conn, :create), setting: params
      {:ok, contents} = File.read("nerves_settings.txt")
      assert params == :erlang.binary_to_term(contents)
    end
  end

  defp authenticated_conn(conn) do
    session_params = %{"password" => "password", "password_confirmation" => "password"}
    conn = post conn, session_path(conn, :create), session: session_params
    recycle(conn)
  end
end
