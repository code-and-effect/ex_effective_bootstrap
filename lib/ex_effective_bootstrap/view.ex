defmodule ExEffectiveBootstrap.View do
  @moduledoc "Main entry point to include all ex_effective_bootstrap modules"
  alias ExEffectiveBootstrap.{Collapse, Form, Icons, Inputs, Submit, Tabs}

  defmacro __using__([]) do
    quote do
      # Form Helpers
      import Form
      import Icons
      import Inputs
      import Submit

      # View Helpers
      import Collapse
      import Tabs
    end
  end
end
