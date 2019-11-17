defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Tags, Options}
  alias Phoenix.HTML.Form

  def input(form, field, opts \\ []) do
    Options.input_type(form, field, opts)
    |> effective_input(form, field, opts)
  end

  # defp effective_input(:checkbox, form, field, opts) do
  #  {options, tags} = build(form, field, opts, %Options{
  #     wrapper: [class: "form-group custom-control custom-checkbox"],
  #     label: [class: "custom-control-label"],
  #     input: [class: "custom-control-input"],
  #   })

  #   content_tag :div, options.wrapper do
  #     [tags.input, tags.label, tags.valid, tags.invalid, tags.hint]
  #   end
  # end

  # defp effective_input(:email_input, form, field, opts) do
  #   {options, tags} = build(form, field, opts, %Options{
  #     prepend: [text: "@", class: "input-group-text"]
  #   })

  #   group = content_tag(:div, class: "input-group") do
  #     [tags.prepend, tags.input, tags.valid, tags.invalid]
  #   end

  #   content_tag :div, options.wrapper do
  #     [tags.label, group, tags.hint]
  #   end
  # end

  defp effective_input(:checkbox, form, field, opts) do
   %Options{
      wrapper: [class: "form-group custom-control custom-checkbox"],
      label: [class: "custom-control-label"],
      input: [class: "custom-control-input"],
    } |> to_html(form, field, opts)
   end

  defp effective_input(_, form, field, opts) do
    %Options{} |> to_html(form, field, opts)
  end

  # build_and_render
  defp to_html(%Options{} = options, form, field, opts \\ []) do
    IO.inspect("TO HTML BUILD AND RENER")
    options
    |> Options.build(form, field, opts)
    |> Tags.build(form, field)
    |> to_html()
  end

  defp to_html({%Tags{} = tags, %Options{type: :checkbox} = options}) do
    IO.inspect("to_HTML CHECKBOX")
    content_tag :div, options.wrapper do
      [tags.input, tags.label, tags.valid, tags.invalid, tags.hint]
    end
  end

  defp to_html({%Tags{} = tags, %Options{input_group: [enabled: true] } = options}) do
    IO.inspect("TO HTML INPUT GROUP")
    IO.inspect(options)

    content_tag :div, options.wrapper do
      [tags.label, tags.input, tags.valid, tags.invalid, tags.hint]
    end
  end

  defp to_html({%Tags{} = tags, %Options{} = options}) do
    IO.inspect("TO HTML default")
    IO.inspect(options)

    content_tag :div, options.wrapper do
      [tags.label, tags.input, tags.valid, tags.invalid, tags.hint]
    end
  end


  #   |> Tags.build(form, )
  #   build(type, form, field, opts)
  #   render()

  #   {options, tags} = build(form, field, opts, %Options{})

  #   content_tag :div, options.wrapper do
  #     [tags.label, tags.input, tags.valid, tags.invalid, tags.hint]
  #   end
  # end

  # defp build(options, form, field opts \\ []) do
  #   tags = Tags.build(options, form, field)

  #   tags = Tags.build(form, field, options)
  #   tags = b
  # end


  # defp build(form, field, opts, %Options{} = options) do
  #   options = Options.build(form, field, options, opts)
  #   tags = Tags.build(form, field, options)
  #   {options, tags}
  # end

end
