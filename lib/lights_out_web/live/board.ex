defmodule LightsOutWeb.Board do
  use LightsOutWeb, :live_view

  # TODO:
  # 1. Load a game ✅
  # 2. Check for win state after events

  def mount(_params, _user, socket) do
    grid = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}
    {:ok, assign(socket, :grid, grid)}
  end

  def handle_params(params, _uri, socket) do
    grid = socket.assigns.grid

    socket =
      case params["game_id"] do
        game when not is_nil(game) ->
          assign(socket, :grid, load_game(grid, String.to_integer(game)))

        _ ->
          socket
      end

    {:noreply, socket}
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY}, socket) do
    x = String.to_integer(strX)
    y = String.to_integer(strY)
    nextX = Kernel.min(4, x + 1)
    prevX = Kernel.max(0, x - 1)
    nextY = Kernel.min(4, y + 1)
    prevY = Kernel.max(0, y - 1)

    grid = socket.assigns.grid

    updated_grid =
      grid
      |> Map.put({x, y}, !grid[{x, y}])
      |> Map.put({prevX, y}, !grid[{prevX, y}])
      |> Map.put({nextX, y}, !grid[{nextX, y}])
      |> Map.put({x, prevY}, !grid[{x, prevY}])
      |> Map.put({x, nextY}, !grid[{x, nextY}])

    {:noreply, assign(socket, :grid, updated_grid)}
  end

  defp load_game(grid, id) do
    games = %{1 => [{2, 0}, {2, 2}, {2, 4}]}

    games
    |> Map.get(id, [])
    |> then(fn game -> update_grid(grid, game) end)
  end

  defp update_grid(grid, []), do: grid

  defp update_grid(grid, [{x, y} | rest]) do
    grid
    |> Map.put({x, y}, true)
    |> update_grid(rest)
  end
end
