defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Tags, Options}
  alias Phoenix.HTML.Form

  def input(form, field, opts \\ []) do
    Options.input_type(form, field, opts)
    |> effective_input(form, field, opts)
  end

  defp effective_input(:checkbox, form, field, opts) do
   {options, tags} = build(form, field, opts, %Options{
      wrapper: [class: "form-group custom-control custom-checkbox"],
      label: [class: "custom-control-label"],
      input: [class: "custom-control-input"],
    })

    content_tag :div, options.wrapper do
      [tags.input, tags.label, tags.valid, tags.invalid, tags.hint]
    end
  end

  defp effective_input(:email_input, form, field, opts) do
    {options, tags} = build(form, field, opts, %Options{
      prepend: [text: "@", class: "input-group-text"]
    })

    group = content_tag(:div, class: "input-group") do
      [tags.prepend, tags.input, tags.valid, tags.invalid]
    end

    content_tag :div, options.wrapper do
      [tags.label, group, tags.hint]
    end
  end

  defp effective_input(type, form, field, opts) do
    {options, tags} = build(form, field, opts, %Options{})

    content_tag :div, options.wrapper do
      [tags.label, tags.input, tags.valid, tags.invalid, tags.hint]
    end
  end

  defp build(form, field, opts, %Options{} = options) do
    options = Options.build(form, field, options, opts)
    tags = Tags.build(form, field, options)
    {options, tags}
  end

end
