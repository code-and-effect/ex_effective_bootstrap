defmodule ExEffectiveBootstrap.View do
  @moduledoc "Main entry point to include all ex_effective_bootstrap modules"

  defmacro __using__([]) do
    quote do
      # Form Helpers
      import ExEffectiveBootstrap.Form
      import ExEffectiveBootstrap.Inputs
      import ExEffectiveBootstrap.ShowIf
      import ExEffectiveBootstrap.Submit

      # View Helpers
      import ExEffectiveBootstrap.Collapse
      import ExEffectiveBootstrap.FlashAlert
      import ExEffectiveBootstrap.Icons
      import ExEffectiveBootstrap.InputsFor
      import ExEffectiveBootstrap.Navs
      import ExEffectiveBootstrap.Tabs
    end
  end
end
