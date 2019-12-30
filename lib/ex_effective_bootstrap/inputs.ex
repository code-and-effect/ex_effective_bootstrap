defmodule ExEffectiveBootstrap.Inputs do
  @moduledoc "Renders all the form inputs"

  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Icons, Tags, Options}

  @spec input(Phoenix.HTML.Form.t(), atom) :: Phoenix.HTML.Safe.t()
  @spec input(Phoenix.HTML.Form.t(), atom, Keyword.t()) :: Phoenix.HTML.Safe.t()
  @spec input(Phoenix.HTML.Form.t(), atom, Keyword.t() | nil, {:do, Phoenix.HTML.Safe.t()}) :: Phoenix.HTML.Safe.t()
  def input(form, field) do
    input(form, field, [])
  end

  def input(form, field, opts) when is_list(opts) do
    effective_input(form, Options.input_type(form, field, opts), field, opts)
  end

  def input(form, field, opts \\ [], do: block) do
    opts = Keyword.merge(opts, [value: block])
    effective_input(form, Options.input_type(form, field, opts), field, opts)
  end

  @spec effective_input(Phoenix.HTML.Form.t(), atom, atom, Keyword.t()) :: Phoenix.HTML.Safe.t()
  def effective_input(form, :email_input, field, opts) do
    %Options{prepend: [text: Icons.icon("at-sign"), class: "input-group-text"]}
    |> to_html(form, field, opts)
  end

  def effective_input(form, :password_input, field, opts) do
    %Options{prepend: [text: Icons.icon(:key), class: "input-group-text"]}
    |> to_html(form, field, opts)
  end

  def effective_input(form, :checkbox, field, opts) do
    %Options{
      wrapper: [class: "form-group custom-control custom-checkbox"],
      label: [class: "custom-control-label"],
      input: [class: "custom-control-input"]
    }
    |> to_html(form, field, opts)
  end

  def effective_input(form, :select, field, opts) do
    %Options{javascript: [method_name: :select]} |> to_html(form, field, opts)
  end

  def effective_input(form, :multiple_select, field, opts) do
    %Options{javascript: [method_name: :select]} |> to_html(form, field, opts)
  end

  def effective_input(form, :static_field, field, opts) do
    %Options{input: [class: "form-control-plaintext"]} |> to_html(form, field, opts)
  end

  def effective_input(form, :telephone_input, field, opts) do
    %Options{
      input: [class: "form-control", placeholder: "(555) 555-5555"],
      javascript: [mask: "(999) 999-9999? x99999", placeholder: "_"],
      prepend: [text: Icons.icon("phone"), class: "input-group-text"]
    }
    |> to_html(form, field, opts)
  end

  def effective_input(form, :text_input, field, opts) do
    %Options{} |> to_html(form, field, opts)
  end

  def effective_input(form, _type, field, opts) do
    %Options{} |> to_html(form, field, opts)
  end

  # build_and_render
  defp to_html(%Options{} = options, form, field, opts) do
    options
    |> Options.build(form, field, opts || [])
    |> Tags.build(form, field)
    |> to_html()
  end

  defp to_html({%Tags{} = tags, %Options{type: :checkbox} = options}) do
    content_tag :div, options.wrapper do
      [tags.input, tags.label, tags.valid, tags.invalid, tags.hint]
    end
  end

  defp to_html({%Tags{} = tags, %Options{type: :hidden_input}}) do
    tags.input
  end

  defp to_html({%Tags{} = tags, %Options{type: :static_field} = options}) do
    content_tag :div, options.wrapper do
      [tags.label, tags.input, tags.hint]
    end
  end

  # defp to_html({%Tags{} = tags, %Options{type: :new_input} = options}) do
  #   content_tag :div, options.wrapper do
  #     [tags.label, tags.input, tags.valid, tags.invalid, tags.hint]
  #   end
  # end

  defp to_html({%Tags{} = tags, %Options{input_group: false} = options}) do
    content_tag :div, options.wrapper do
      [tags.label, tags.input, tags.valid, tags.invalid, tags.hint]
    end
  end

  defp to_html({%Tags{} = tags, %Options{} = options}) do
    input_group_tags = [tags.prepend, tags.input, tags.append, tags.valid, tags.invalid]

    content_tag :div, options.wrapper do
      [tags.label, content_tag(:div, input_group_tags, options.input_group), tags.hint]
    end
  end
end
