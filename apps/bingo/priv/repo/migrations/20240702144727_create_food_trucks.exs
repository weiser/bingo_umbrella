defmodule Bingo.Repo.Migrations.CreateFoodTrucks do
  use Ecto.Migration

  def change do
    create table(:food_trucks) do
      add(:location_id, :integer, primary_key: true)
      add(:applicant, :string)
      add(:facility_type, :string)
      add(:cnn, :integer)
      add(:location_description, :string)
      add(:address, :string)
      add(:blocklot, :string)
      add(:block, :string)
      add(:lot, :string)
      add(:permit, :string)
      add(:status, :string)
      add(:food_items, :string)
      add(:x, :float)
      add(:y, :float)
      add(:latitude, :float)
      add(:longitude, :float)
      add(:schedule, :string)
      add(:dayshours, :string)
      add(:noi_sent, :string)
      add(:approved, :string)
      add(:received, :integer)
      add(:prior_permit, :integer)
      add(:expiration_date, :string)
      add(:location, :string)
      add(:fire_prevention_districts, :integer)
      add(:police_districts, :integer)
      add(:supervisor_districts, :integer)
      add(:zip_codes, :integer)
      add(:neighborhoods_old, :integer)
    end
  end
end
