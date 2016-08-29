defmodule BadgeSessions.SessionTest do
  use BadgeSettings.ModelCase

  alias BadgeSettings.Session

  describe ".create_changeset" do
    test "password is required" do
      changeset = Session.create_changeset(%Session{}, %{"password_confirmation" => "wrong"})
      refute changeset.valid?
    end

    test "changeset is valid when the password matches the password_confirmation" do
      changeset = Session.create_changeset(%Session{}, %{"password" => "password", "password_confirmation" => "password"})
      assert changeset.valid?
    end

    test "changeset is not valid when the password doesn't match the password_confirmation" do
      changeset = Session.create_changeset(%Session{}, %{"password" => "password", "password_confirmation" => "wrong"})
      refute changeset.valid?
    end
  end

  describe ".new_changeset" do
    test "password is not required" do
      changeset = Session.new_changeset(%Session{}, %{"password_confirmation" => "wrong"})
      assert changeset.valid?
    end
  end
end
