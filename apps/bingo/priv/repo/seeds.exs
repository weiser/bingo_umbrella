# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bingo.Repo.insert!(%Bingo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

path_to_food_trucks =
  :bingo |> :code.priv_dir() |> Path.join(~w[data / Mobile_Food_Facility_Permit.csv])

Bingo.FoodTruck.load_from_csv(path_to_food_trucks)
