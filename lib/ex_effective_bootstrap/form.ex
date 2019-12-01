defmodule ExEffectiveBootstrap.Form do
  @moduledoc """
  Call effective_form for the same way as phoenix form_for
  But use the input syntax instead.

  <%= effective_form_for @changeset, Routes.foo_path(@conn, :update) fn f -> %>
    <%= input f, :email %>
    <%= input f, :password %>
    <%= input f, :author_id, select: author_ids(), selected: 1 %>
    <%= effective_submit "Save" %>
  <% end %>
  """

  use Phoenix.HTML
  alias ExEffectiveBootstrap.Options

  @spec effective_form_for(any, String.t()) :: any
  def effective_form_for(form_data, action) do
    form_for(form_data, action, [])
  end

  @spec effective_form_for(any, String.t(), Keyword.t()) ::
          any
  def effective_form_for(form_data, action, options) when is_list(options) do
    form_for(form_data, action, Options.form_options(form_data, options))
  end

  @spec effective_form_for(
          any,
          String.t(),
          (any -> Phoenix.HTML.unsafe())
        ) :: Phoenix.HTML.safe()
  @spec effective_form_for(
          any,
          String.t(),
          Keyword.t(),
          (any -> Phoenix.HTML.unsafe())
        ) :: Phoenix.HTML.safe()
  def effective_form_for(form_data, action, options \\ [], fun) when is_function(fun, 1) do
    %{action: action, options: options} = form = effective_form_for(form_data, action, options)
    html_escape([form_tag(action, options), fun.(form), raw("</form>")])
  end
end
