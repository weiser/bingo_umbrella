defmodule Bingo.FoodTruck do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "food_trucks" do
    field(:location_id, :integer, primary_key: true)
    field(:applicant, :string)
    field(:facility_type, :string)
    field(:cnn, :integer)
    field(:location_description, :string)
    field(:address, :string)
    field(:blocklot, :string)
    field(:block, :string)
    field(:lot, :string)
    field(:permit, :string)
    field(:status, :string)
    field(:food_items, :string)
    field(:x, :float)
    field(:y, :float)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:schedule, :string)
    field(:dayshours, :string)
    field(:noi_sent, :string)
    field(:approved, :string)
    field(:received, :integer)
    field(:prior_permit, :integer)
    field(:expiration_date, :string)
    field(:location, :string)
    field(:fire_prevention_districts, :integer)
    field(:police_districts, :integer)
    field(:supervisor_districts, :integer)
    field(:zip_codes, :integer)
    field(:neighborhoods_old, :integer)
  end

  @doc """
  Inserts food truck records into the food_trucks table, from a CSV that is in location `path_to_csv`.
  Records that do not have a locationDescription in the CSV are skipped because you cannot go to a food truck that has no listed location
  """
  @spec load_from_csv(String.t()) :: none()
  def load_from_csv(path_to_csv) do
    changesets =
      Enum.map(from_csv(path_to_csv), fn food_truck ->
        Bingo.FoodTruck.changeset(%Bingo.FoodTruck{}, Map.from_struct(food_truck))
      end)

    for cs <- changesets do
      Bingo.Repo.insert!(cs, on_conflict: :replace_all)
    end
  end

  defp from_csv(path_to_csv) do
    food_trucks = path_to_csv |> File.stream!() |> CSV.decode()
    [ok: header] = Enum.take(food_trucks, 1)
    rows = Enum.drop(food_trucks, 1)

    if not csv_has_valid_headers?(header) do
      raise "#{path_to_csv} does not have required columns.  Expected '#{known_csv_header()}', got '#{header}'"
    end

    # here, we create FoodTruck structs using maps of column, value pairs,
    # but filter out food trucks that have no location description because we cannot go to a food truck that has no location listed
    Enum.filter(
      Enum.map(
        rows,
        fn {:ok, row} ->
          params =
            List.zip([header, row])
            |> Map.new(fn {k, v} -> {known_csv_header_to_fields()[k], v} end)

          struct(Bingo.FoodTruck, params)
        end
      ),
      fn food_truck ->
        String.length(food_truck.location_description) > 0
      end
    )
  end

  defp csv_has_valid_headers?(headers) do
    length(known_csv_header() -- headers) == 0
  end

  defp known_csv_header_to_fields() do
    List.zip([known_csv_header(), fields()])
    |> Map.new()
  end

  defp known_csv_header() do
    [
      "locationid",
      "Applicant",
      "FacilityType",
      "cnn",
      "LocationDescription",
      "Address",
      "blocklot",
      "block",
      "lot",
      "permit",
      "Status",
      "FoodItems",
      "X",
      "Y",
      "Latitude",
      "Longitude",
      "Schedule",
      "dayshours",
      "NOISent",
      "Approved",
      "Received",
      "PriorPermit",
      "ExpirationDate",
      "Location",
      "Fire Prevention Districts",
      "Police Districts",
      "Supervisor Districts",
      "Zip Codes",
      "Neighborhoods (old)"
    ]
  end

  defp fields() do
    [
      :location_id,
      :applicant,
      :facility_type,
      :cnn,
      :location_description,
      :address,
      :blocklot,
      :block,
      :lot,
      :permit,
      :status,
      :food_items,
      :x,
      :y,
      :latitude,
      :longitude,
      :schedule,
      :dayshours,
      :noi_sent,
      :approved,
      :received,
      :prior_permit,
      :expiration_date,
      :location,
      :fire_prevention_districts,
      :police_districts,
      :supervisor_districts,
      :zip_codes,
      :neighborhoods_old
    ]
  end

  def changeset(food_truck, params \\ %{}) do
    food_truck
    |> cast(params, fields())
  end
end
