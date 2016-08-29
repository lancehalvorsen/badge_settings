defmodule BadgeSettings.Session do
  use BadgeSettings.Web, :model

  schema "settings" do
    field :password, :string
    field :password_confirmation, :string #, virtual: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def new_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password, :password_confirmation])
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password, :password_confirmation])
    |> validate_required([:password])
    |> validate_confirmation(:password)
  end
end
