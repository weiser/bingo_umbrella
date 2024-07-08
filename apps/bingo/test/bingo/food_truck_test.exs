defmodule Bingo.FoodTruckTest do
  use Bingo.DataCase
  use ExUnit.Case

  describe ".load_from_csv" do
    test "loads food_trucks table from a CSV file.  Excludes food trucks w/ no location description" do
      path_to_food_trucks =
        :bingo |> :code.priv_dir() |> Path.join(~w[data / Mobile_Food_Facility_Permit.csv])

      Bingo.FoodTruck.load_from_csv(path_to_food_trucks)
      # there are 21 rows that have no location description.
      # if we don't know where they are, we can't go to them.
      assert 608 = Bingo.Repo.aggregate(Bingo.FoodTruck, :count)

      assert %Bingo.FoodTruck{location_id: 1_569_152} =
               Bingo.Repo.one!(from ft in Bingo.FoodTruck, where: ft.location_id == 1_569_152)

      food_trucks_no_location_desc =
        from ft in Bingo.FoodTruck, where: ft.location_description == ""

      assert 0 = Bingo.Repo.aggregate(food_trucks_no_location_desc, :count)
    end

    test "raises an error when a FoodTruck cannot be made" do
      {:ok, cwd} = File.cwd()

      path_to_food_trucks =
        "#{cwd}/test/data/Bad_Mobile_Food_Facility_Permit.csv"

      assert_raise RuntimeError, fn -> Bingo.FoodTruck.load_from_csv(path_to_food_trucks) end
    end
  end
end
