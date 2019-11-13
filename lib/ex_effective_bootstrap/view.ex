defmodule ExEffectiveBootstrap.View do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Form, Icons, Inputs}

  defmacro __using__([]) do
    quote do
      import Form
      import Icons
      import Inputs
    end
  end
end
