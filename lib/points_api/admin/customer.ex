defmodule PointsApi.Admin.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "customers" do
    field :balance, :integer
    field :email, :string
    field :phone, :string

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:email, :phone, :balance])
    |> validate_one_of_present([:email, :phone])
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
    |> unique_constraint(:phone)
  end

  """
  Need to validate if one at least either email or phone is present.
  Source https://stackoverflow.com/questions/46330499/validate-required-for-one-out-of-three.
  """
  def validate_one_of_present(changeset, fields) do
    fields
    |> Enum.filter(fn field ->
      case get_field(changeset, field) do
        nil -> false
        _ -> true
      end
    end)
    |> case do
      # feel like theres a better way to do this?
      [_] ->
        changeset
      [_, _] ->
        changeset
      _ ->
        add_error(changeset, hd(fields), "Expected exactly one of #{inspect(fields)} to be present")
    end
  end

end
