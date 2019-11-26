defmodule ExEffectiveBootstrap.Validate do
  @moduledoc "validate your Ecto changeset"
  import Ecto.Changeset

  @doc "Validate a string field is a telephone number format matches (444) 444-4444 x12345"
  @spec telephone(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t()
  def telephone(%Ecto.Changeset{} = changeset, key) do
    with phone_number <- get_field(changeset, key),
         false <- is_nil(phone_number),
         false <- Regex.match?(~r/^\(\d{3}\) \d{3}-\d{4}(.*)$/, phone_number) do
      add_error(changeset, key, "must be a 10-digit phone number")
    else
      _ -> changeset
    end
  end

end
