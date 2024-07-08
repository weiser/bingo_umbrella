defmodule Bingo.Repo do
  use Ecto.Repo,
    otp_app: :bingo,
    adapter: Ecto.Adapters.SQLite3

  import Ecto.Query

  def random_food_trucks(number) do
    query = from Bingo.FoodTruck, order_by: fragment("RANDOM()"), limit: ^number
    Bingo.Repo.all(query)
  end
end
