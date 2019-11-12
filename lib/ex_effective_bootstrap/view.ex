defmodule ExEffectiveBootstrap.View do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Form, Inputs}

  defmacro __using__([]) do
    quote do
      import Form
      import Inputs
    end
  end
end
