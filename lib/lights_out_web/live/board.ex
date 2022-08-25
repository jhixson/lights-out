defmodule LightsOutWeb.Board do
  use LightsOutWeb, :live_view

  @grid_size 5

  def mount(_params, _user, socket) do
    grid = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}
    {:ok, assign(socket, grid: grid, win: false)}
  end

  def handle_params(params, _uri, socket) do
    grid = socket.assigns.grid

    socket =
      case params["game_id"] do
        game when not is_nil(game) ->
          assign(socket, grid: load_game(grid, String.to_integer(game)), win: false)

        _ ->
          socket
      end

    {:noreply, socket}
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY}, socket) do
    x = String.to_integer(strX)
    y = String.to_integer(strY)
    nextX = Kernel.min(@grid_size - 1, x + 1)
    prevX = Kernel.max(0, x - 1)
    nextY = Kernel.min(@grid_size - 1, y + 1)
    prevY = Kernel.max(0, y - 1)

    grid = socket.assigns.grid

    updated_grid =
      grid
      |> Map.put({x, y}, !grid[{x, y}])
      |> Map.put({prevX, y}, !grid[{prevX, y}])
      |> Map.put({nextX, y}, !grid[{nextX, y}])
      |> Map.put({x, prevY}, !grid[{x, prevY}])
      |> Map.put({x, nextY}, !grid[{x, nextY}])

    win = check_win(updated_grid)

    {:noreply, assign(socket, grid: updated_grid, win: win)}
  end

  defp load_game(grid, id) do
    games = %{
      1 => [{2, 0}, {2, 2}, {2, 4}],
      2 => [
        {0, 0},
        {0, 2},
        {0, 4},
        {1, 0},
        {1, 2},
        {1, 4},
        {3, 0},
        {3, 2},
        {3, 4},
        {4, 0},
        {4, 2},
        {4, 4}
      ],
      3 => [
        {0, 1},
        {0, 3},
        {1, 0},
        {1, 1},
        {1, 3},
        {1, 4},
        {2, 0},
        {2, 1},
        {2, 3},
        {2, 4},
        {3, 0},
        {3, 1},
        {3, 3},
        {3, 4},
        {4, 1},
        {4, 3}
      ],
      4 => [
        {1, 0},
        {1, 1},
        {1, 3},
        {1, 4},
        {3, 0},
        {3, 4},
        {4, 0},
        {4, 1},
        {4, 3},
        {4, 4}
      ],
      5 => [
        {0, 0},
        {0, 1},
        {0, 2},
        {0, 3},
        {1, 0},
        {1, 1},
        {1, 2},
        {1, 4},
        {2, 0},
        {2, 1},
        {2, 2},
        {2, 4},
        {3, 3},
        {3, 4},
        {4, 0},
        {4, 1},
        {4, 3},
        {4, 4}
      ],
      6 => [
        {2, 0},
        {2, 2},
        {2, 4},
        {3, 0},
        {3, 2},
        {3, 4},
        {4, 1},
        {4, 2},
        {4, 3}
      ]
    }

    games
    |> Map.get(id, [])
    |> then(fn game -> setup_tiles(grid, game) end)
  end

  defp setup_tiles(grid, []), do: grid

  defp setup_tiles(grid, [{x, y} | rest]) do
    grid
    |> Map.put({x, y}, true)
    |> setup_tiles(rest)
  end

  defp check_win(grid) do
    grid
    |> Map.values()
    |> Enum.all?(&(!&1))
  end
end
