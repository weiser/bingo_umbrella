defmodule BingoWeb.PageController do
  use BingoWeb, :controller

  def bingo_card(conn, _params) do
    render(conn, :bingo_card, food_trucks: Bingo.Repo.random_food_trucks(25), layout: false)
  end
end
