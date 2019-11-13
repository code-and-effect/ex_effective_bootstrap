defmodule ExEffectiveBootstrap.Form do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.Options

  @spec effective_form_for(Phoenix.HTML.FormData.t(), String.t()) :: Phoenix.HTML.Form.t()
  def effective_form_for(form_data, action) do
    form_for(form_data, action, [])
  end

  @spec effective_form_for(Phoenix.HTML.FormData.t(), String.t(), Keyword.t()) ::
          Phoenix.HTML.Form.t()
  def effective_form_for(form_data, action, options) when is_list(options) do
    form_for(form_data, action, Options.form_options(form_data, options))
  end

  @spec effective_form_for(Phoenix.HTML.FormData.t(), String.t(), Keyword.t(), any) ::
          Phoenix.HTML.safe()
  def effective_form_for(form_data, action, options \\ [], fun) when is_function(fun, 1) do
    %{action: action, options: options} = form = effective_form_for(form_data, action, options)
    html_escape([form_tag(action, options), fun.(form), raw("</form>")])
  end
end
