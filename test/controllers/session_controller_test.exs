defmodule BadgeSettings.SessionControllerTest do
  use BadgeSettings.ConnCase

  @device_name Application.get_env(:badge_settings, :nerves_settings).device_name

  describe ".index" do
    test "redirects to the new action", %{conn: conn} do
      conn = get conn, "/session"
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end

  describe ".new" do
    test "renders the new template", %{conn: conn} do
      conn = get conn, "/session/new"
      assert html_response(conn, 200) =~ "Please enter you password below"
    end
  end

  describe ".create when passwords don't match" do
    test "re-renders the new template with error message", %{conn: conn} do
      session_params = %{"password" => "password", "password_confirmation" => "wrong"}
      conn = post conn, session_path(conn, :create), session: session_params
      assert html_response(conn, 200) =~ "Oops, that's the wrong password."
    end
  end

  describe ".create when passwords do match" do
    test "sets a session key", %{conn: conn} do
      session_params = %{"password" => "password", "password_confirmation" => "password"}
      conn = post conn, session_path(conn, :create), session: session_params
      assert get_session(conn, :device_name) == @device_name
    end

    test "redirects to the settings new action", %{conn: conn} do
      session_params = %{"password" => "password", "password_confirmation" => "password"}
      conn = post conn, session_path(conn, :create), session: session_params
      assert redirected_to(conn) == setting_path(conn, :new)
    end
  end

  describe ".delete" do
    test "redirects to the session new action", %{conn: conn} do
      conn = delete conn, session_path(conn, :delete, %BadgeSettings.Session{id: "delete"})
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "unsets the session key", %{conn: conn} do
      session_params = %{"password" => "password", "password_confirmation" => "password"}
      conn = post conn, session_path(conn, :create), session: session_params
      conn = recycle(conn)
      conn = delete conn, session_path(conn, :delete, %BadgeSettings.Session{id: "delete"})
      assert get_session(conn, :device_name) == nil
    end
  end
end
