defmodule BadgeSettings.Setting do
  use BadgeSettings.Web, :model

  schema "settings" do
    field :ssid, :string
    field :password, :string
    field :handle, :string
    field :hashtag, :string
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:ssid, :password, :handle, :hashtag])
    |> validate_required([:ssid, :password, :handle, :hashtag])
    |> validate_format(:handle, ~r/^@/, message: "Must begin with @")
    |> validate_length(:handle, min: 2)
    |> validate_length(:handle, max: 16)
    |> validate_format(:hashtag, ~r/^#/, message: "Must begin with #")
    |> validate_length(:hashtag, min: 2)
    |> validate_length(:hashtag, max: 140)
    |> validate_length(:password, min: 8)
    |> validate_length(:password, max: 50)
    |> validate_length(:ssid, max: 32)
  end
end
