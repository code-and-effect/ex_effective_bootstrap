defmodule ExEffectiveBootstrap.View do
  alias ExEffectiveBootstrap.{Form, Icons, Inputs}

  defmacro __using__([]) do
    quote do
      import Form
      import Icons
      import Inputs
    end
  end
end
