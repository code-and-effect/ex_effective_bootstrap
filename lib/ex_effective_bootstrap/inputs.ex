defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Icons, Tags, Options}
  alias Phoenix.HTML.Form

  def input(form, field, opts \\ []) do
    Options.input_type(form, field, opts)
    |> effective_input(form, field, opts)
  end

  defp effective_input(:email_input, form, field, opts) do
    %Options{prepend: [text: Icons.icon("at-sign"), class: "input-group-text"]}
    |> to_html(form, field, opts)
  end

  defp effective_input(:password_input, form, field, opts) do
    %Options{prepend: [text: Icons.icon(:key), class: "input-group-text"]}
    |> to_html(form, field, opts)
  end

  defp effective_input(:checkbox, form, field, opts) do
    %Options{
      wrapper: [class: "form-group custom-control custom-checkbox"],
      label: [class: "custom-control-label"],
      input: [class: "custom-control-input"]
    }
    |> to_html(form, field, opts)
  end

  defp effective_input(_, form, field, opts) do
    %Options{} |> to_html(form, field, opts)
  end

  # build_and_render
  defp to_html(%Options{} = options, form, field, opts \\ []) do
    options
    |> Options.build(form, field, opts)
    |> Tags.build(form, field)
    |> to_html()
  end

  defp to_html({%Tags{} = tags, %Options{type: :checkbox} = options}) do
    content_tag :div, options.wrapper do
      [tags.input, tags.label, tags.valid, tags.invalid, tags.hint]
    end
  end

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
