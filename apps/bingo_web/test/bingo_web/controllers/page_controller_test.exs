defmodule BingoWeb.PageControllerTest do
  use BingoWeb.ConnCase
  use AssertHTML

  setup do
    path_to_food_trucks =
      :bingo |> :code.priv_dir() |> Path.join(~w[data / Mobile_Food_Facility_Permit.csv])

    Bingo.FoodTruck.load_from_csv(path_to_food_trucks)
    :ok
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    html_response(conn, 200)
    # there should be 25 squares
    |> assert_html("label", min: 25)
    |> assert_html("label", max: 25)
  end
end
