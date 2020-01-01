defmodule ExEffectiveBootstrap.InputsFor do
  @moduledoc "Bootstrap has_many form builder"
  use Phoenix.HTML
  alias Phoenix.HTML.Form
  alias ExEffectiveBootstrap.Icons

  @doc """
  A nested fields has_many builder. Includes Add Another and Delete buttons.
  Works with a regular phoenix form_for and effective_form_for

  ## Example
  <%= effective_form_for @changeset, @action, fn f -> %>
    <%= input f, :name %>

    <%= effective_inputs_for f, :comments, fn comment -> %>
      <%= render("_comment_fields.html", form: comment) %>
  <% end %>

  The _comment_fields.html must start with <div class="nested-fields">

  <div class="nested-fields">
    <%= input @form, :title %>
    <%= input @form, :body %>
  </div>
  """
  @spec effective_inputs_for(
          Phoenix.HTML.FormData.t(),
          atom,
          Keyword.t(),
          (Phoenix.HTML.Form.t() -> Phoenix.HTML.unsafe())
        ) :: Phoenix.HTML.safe()
  def effective_inputs_for(form, field, opts \\ [], fun) do
    associated = Ecto.build_assoc(form.data, field)
    valid_form = Map.put(form, :params, %{})
    template = Form.inputs_for(valid_form, field, [prepend: [associated]], fun)

    content_tag(:div, class: "effective-inputs-for") do
      [
        Form.inputs_for(form, field, opts, fun),
        content_tag(:div, effective_inputs_for_add_link(opts), class: "effective-inputs-for-links"),
        content_tag(:div, template, class: "effective-inputs-for-template", style: "display: none;")
      ]
    end
  end

  @spec effective_inputs_for_add_link(Keyword.t()) :: Phoenix.HTML.safe()
  def effective_inputs_for_add_link(opts \\ []) do
    opts =
      [
        title: "Add Another",
        href: "#",
        class: "btn btn-secondary",
        "data-effective-inputs-for-add": "true"
      ]
      |> Keyword.merge(opts)

    content_tag(:a, [Icons.icon("plus-circle"), " ", opts[:title]], opts)
  end

  @spec effective_inputs_for_remove_link(Phoenix.HTML.FormData.t(), atom, Keyword.t()) ::
          Phoenix.HTML.safe()
  def effective_inputs_for_remove_link(form, field, opts \\ []) do
    opts =
      [
        title: "Delete",
        href: "#",
        class: "btn btn-danger",
        "data-effective-inputs-for-delete": "true"
      ]
      |> Keyword.merge(opts)

    input = Form.hidden_input(form, field)
    link = content_tag(:a, Icons.icon("trash-2"), opts)

    if form.data.id, do: [input, link], else: link
  end
end
