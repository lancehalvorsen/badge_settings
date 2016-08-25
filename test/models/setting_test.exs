defmodule BadgeSettings.SettingTest do
  use BadgeSettings.ModelCase

  alias BadgeSettings.Setting

  @valid_attrs %{handle: "@some_content", hashtag: "#some_content", password: "some content", ssid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Setting.changeset(%Setting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Setting.changeset(%Setting{}, @invalid_attrs)
    refute changeset.valid?
  end

  describe "the handle attribute" do
    test "handle is required" do
      changeset = Setting.changeset(%Setting{}, Map.delete(@valid_attrs, :handle))
      refute changeset.valid?
    end

    test "the handle begins with an @" do
      valid_attrs = Map.put(@valid_attrs, :handle, "bad_handle")
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end

    test "the handle is at least two characters long" do
      valid_attrs = Map.put(@valid_attrs, :handle, "@")
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end

    test "the handle is at most sixteen characters long" do
      valid_attrs = Map.put(@valid_attrs, :handle, "@1111111111111111")
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end
  end

  describe "the hashtag attribute" do
    test "hashtag is required" do
      changeset = Setting.changeset(%Setting{}, Map.delete(@valid_attrs, :hashtag))
      refute changeset.valid?
    end

    test "the hashtag begins with an #" do
      valid_attrs = Map.put(@valid_attrs, :hashtag, "bad_hashtag")
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end

    test "the hashtag is at least two characters long" do
      valid_attrs = Map.put(@valid_attrs, :hashtag, "#")
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end

    test "the hashtag is at most 140 characters long" do
      long_string = "#" <> Enum.join((1..75))
      valid_attrs = Map.put(@valid_attrs, :hashtag, long_string)
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end
  end

  describe "the password attribute" do
    test "password is required" do
      changeset = Setting.changeset(%Setting{}, Map.delete(@valid_attrs, :password))
      refute changeset.valid?
    end

    test "the password is at least 8 characters" do
      valid_attrs = Map.put(@valid_attrs, :password, "1234567")
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end

    test "the password is at most 50 characters" do
      long_string = Enum.join((1..50))
      valid_attrs = Map.put(@valid_attrs, :password, long_string)
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end
  end

  describe "the ssid attribute" do
    test "ssid is required" do
      changeset = Setting.changeset(%Setting{}, Map.delete(@valid_attrs, :ssid))
      refute changeset.valid?
    end

    test "the ssid is at most 32 characters" do
      long_string = Enum.join((1..21))
      valid_attrs = Map.put(@valid_attrs, :ssid, long_string)
      changeset = Setting.changeset(%Setting{}, valid_attrs)
      refute changeset.valid?
    end
  end
end
