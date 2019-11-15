defmodule ExEffectiveBootstrap.View do
  alias ExEffectiveBootstrap.{Form, Icons, Inputs, Submit}

  defmacro __using__([]) do
    quote do
      import Form
      import Icons
      import Inputs
      import Submit
    end
  end
end
