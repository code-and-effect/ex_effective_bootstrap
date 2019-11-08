defmodule ExEffectiveBootstrap.View do
  use Phoenix.HTML

  defmacro __using__([]) do
    quote do
      import ExEffectiveBootstrap.Form
    end
  end
end
