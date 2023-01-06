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

  @castable ~w(
    email
    phone
    balance
  )a

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, @castable)
    |> validate_one_of_present([:email, :phone])
    |> unique_constraint(:email)
    |> unique_constraint(:phone)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:phone, ~r/\A\+?[0-9]{3,}/)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
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
      [_] ->
        changeset
      [_, _] ->
        changeset
      _ ->
        add_error(changeset, hd(fields), "Expected exactly one of #{inspect(fields)} to be present")
    end
  end

end
