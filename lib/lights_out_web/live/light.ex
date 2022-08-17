defmodule LightsOutWeb.Light do
  use LightsOutWeb, :live_component

  def render(assigns) do
    ~H"""
    <button class={toggleClass(@on)} phx-click="toggle" phx-value-x={@x} phx-value-y={@y}></button>
    """
  end

  def toggleClass(on) do
    base = ~w(block h-20 px-4 py-6 text-center border rounded)

    case on do
      true -> ["bg-rose-400" | base]
      _ -> ["bg-stone-300" | base]
    end
  end
end
