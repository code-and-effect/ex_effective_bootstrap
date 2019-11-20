defmodule ExEffectiveBootstrap.View do
  @moduledoc "Main entry point to include all ex_effective_bootstrap modules"
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
