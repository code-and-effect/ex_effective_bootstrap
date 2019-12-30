defmodule ExEffectiveBootstrap.Options do
  @moduledoc "Normalizes and initializes all passed options"
  alias ExEffectiveBootstrap.Feedback
  alias Phoenix.HTML.Form

  defstruct type: nil,
            required: nil,
            select_options: nil,
            wrapper: [class: "form-group"],
            input: [class: "form-control"],
            label: [],
            javascript: [],
            hint: [class: "form-text text-muted"],
            valid: [class: "valid-feedback"],
            invalid: [class: "invalid-feedback"],
            prepend: [class: "input-group-text"],
            append: [class: "input-group-text"],
            input_group: [class: "input-group"]

  @type t :: %__MODULE__{
          type: atom | nil,
          required: boolean() | nil,
          select_options: any | nil,
          wrapper: Keyword.t(),
          input: Keyword.t(),
          label: Keyword.t() | false,
          javascript: Keyword.t() | false,
          hint: Keyword.t() | false,
          valid: Keyword.t() | false,
          invalid: Keyword.t() | false,
          prepend: Keyword.t() | false,
          append: Keyword.t() | false,
          input_group: Keyword.t() | false
        }

  @spec form_options(Phoenix.HTML.Form.t() | atom, Keyword.t()) :: Keyword.t()
  def form_options(form, opts \\ []) do
    default = [
      class: "effective-form needs-validation",
      novalidate: true,
      onsubmit: "return EffectiveForm.validate(this);",
      "phx-hook": "EffectiveForm"
    ]

    with_errors = if with_errors?(form), do: [class: "with-errors"]

    default
    |> merge(with_errors)
    |> merge(opts)
  end

  @spec input_type(Phoenix.HTML.Form.t() | atom, atom, Keyword.t()) :: atom
  def input_type(form, field, opts \\ []) do
    cond do
      opts[:type] ->
        opts[:type]

      opts[:as] ->
        opts[:as]

      opts[:select] ->
        :select

      opts[:multiple_select] ->
        :multiple_select

      String.contains?("#{field}", "phone") ->
        :telephone_input

      true ->
        suggested = Form.input_type(form, field)

        case suggested do
          :date_select -> :date_input
          _ -> suggested
        end
    end
  end

  @spec to_options(Map.t()) :: t()
  def to_options(map), do: struct(__MODULE__, map)

  @spec build(t(), Phoenix.HTML.Form.t() | atom, atom, Keyword.t()) :: t()
  def build(%__MODULE__{} = options, form, field, opts \\ []) do
    Map.from_struct(options)
    |> update(:type, form, field, opts)
    |> update(:required, form, field, opts)
    |> update(:select_options, form, field, opts)
    |> update(:wrapper, form, field, opts)
    |> update(:label, form, field, opts)
    |> update(:javascript, form, field, opts)
    |> update(:hint, form, field, opts)
    |> update(:valid, form, field, opts)
    |> update(:invalid, form, field, opts)
    |> update(:prepend, form, field, opts)
    |> update(:append, form, field, opts)
    |> update(:input_group, form, field, opts)
    |> update(:input, form, field, opts)
    |> to_options()
  end

  defp update(options, :type, form, field, opts) do
    Map.put(options, :type, input_type(form, field, opts))
  end

  defp update(options, :select_options, _form, _field, opts) do
    if Enum.member?([:select, :multiple_select], options[:type]) do
      select_options = get_select_options(opts[:select] || opts[:multiple_select])
      Map.put(options, :select_options, select_options)
    else
      Map.put(options, :select_options, false)
    end
  end

  defp get_select_options([%_{id: _id} | _] = collection) do
    Enum.into(collection, %{}, fn struct -> {to_string(struct), struct.id} end)
  end

  defp get_select_options(collection), do: collection

  defp update(options, :required, form, field, opts) do
    required =
      cond do
        Keyword.has_key?(opts, :required) -> opts[:required]
        Keyword.has_key?(opts[:input] || [], :required) -> opts.input[:required]
        true -> Keyword.get(Form.input_validations(form, field), :required, false)
      end

    Map.put(options, :required, !!required)
  end

  defp update(options, :input, form, field, opts) do
    drop = [
      :label,
      :javascript,
      :as,
      :input,
      :type,
      :valid,
      :invalid,
      :wrapper,
      :hint,
      :prepend,
      :append,
      :select,
      :multiple_select
    ]

    opts = merge(opts[:input], Keyword.drop(opts, drop))

    validations = Form.input_validations(form, field)
    with_errors = input_with_errors(form, field)
    with_hint = input_with_hint(options, form, field)
    with_id = input_with_id(options, form, field)
    with_js = input_with_javascript(options)

    merged_opts =
      []
      |> merge(validations)
      |> merge(with_errors)
      |> merge(with_hint)
      |> merge(with_id)
      |> merge(with_js)
      |> merge(opts)

    Map.put(options, :input, merge(options.input, merged_opts))
  end

  defp update(options, key, form, field, opts) do
    put(options, key, opts[key], form, field)
  end

  defp put(options, key, false, _, _), do: Map.put(options, key, false)
  defp put(options, key, nil, form, field), do: put(options, key, [], form, field)

  defp put(options, key, value, form, field) when is_list(value) == false do
    put(options, key, [text: value], form, field)
  end

  defp put(options, :wrapper, opts, _, _) do
    Map.put(options, :wrapper, merge(options[:wrapper], opts))
  end

  defp put(options, :label, opts, form, field) do
    opts = [text: Form.humanize(field), for: Form.input_id(form, field)] |> merge(opts)
    Map.put(options, :label, merge(options[:label], opts))
  end

  defp put(options, :javascript, opts, _, _) do
    Map.put(options, :javascript, merge(options[:javascript], opts))
  end

  defp put(options, :hint, opts, form, field) do
    if opts[:text] do
      opts = [id: "#{Form.input_id(form, field)}_hint"] |> merge(opts)
      Map.put(options, :hint, merge(options[:hint], opts))
    else
      Map.put(options, :hint, false)
    end
  end

  defp put(options, :valid, opts, form, field) do
    opts = [text: Feedback.valid(options, form, field)] |> merge(opts)
    Map.put(options, :valid, merge(options[:valid], opts))
  end

  defp put(options, :invalid, opts, form, field) do
    opts = [text: Feedback.invalid(options, form, field)] |> merge(opts)
    Map.put(options, :invalid, merge(options[:invalid], opts))
  end

  defp put(options, :prepend, opts, _, _) do
    if options[:prepend][:text] || opts[:text] do
      Map.put(options, :prepend, merge(options[:prepend], opts))
    else
      Map.put(options, :prepend, false)
    end
  end

  defp put(options, :append, opts, _, _) do
    if options[:append][:text] || opts[:text] do
      Map.put(options, :append, merge(options[:append], opts))
    else
      Map.put(options, :append, false)
    end
  end

  defp put(options, :input_group, opts, _, _) do
    if options[:prepend] || options[:append] do
      Map.put(options, :input_group, merge(options[:input_group], opts))
    else
      Map.put(options, :input_group, false)
    end
  end

  @spec merge(Keyword.t() | nil, Keyword.t() | nil) :: Keyword.t()
  def merge(nil, opts) when is_list(opts), do: opts
  def merge(options, nil) when is_list(options), do: options

  def merge(options, opts) when is_list(options) and is_list(opts) do
    Keyword.merge(options, opts) |> merge_class(options[:class], opts[:class])
  end

  defp input_with_errors(form, field) do
    cond do
      !with_errors?(form) -> []
      form.errors[field] -> [class: "is-invalid"]
      true -> [class: "is-valid"]
    end
  end

  defp input_with_hint(options, form, field) do
    if options.hint do
      ["aria-describedby": "#{Form.input_id(form, field)}_hint"]
    end
  end

  defp input_with_javascript(options) do
    if options.javascript && length(options.javascript) > 0 do
      json =
        [method_name: options.type]
        |> merge(options.javascript)
        |> Enum.into(%{}, fn {k, v} -> {k, v} end)
        |> Jason.encode!()

      ["data-input-js-options": json]
    end
  end

  # We only need this for static_field, otherwise it's added automatically
  defp input_with_id(options, form, field) do
    if options.type == :static_field do
      [id: Form.input_id(form, field)]
    end
  end

  # submitted with errors
  defp with_errors?(%Phoenix.HTML.Form{source: source}), do: with_errors?(source)
  defp with_errors?(%Ecto.Changeset{} = source), do: !is_nil(source.action)
  defp with_errors?(_), do: false

  defp merge_class(options, nil, nil), do: options
  defp merge_class(options, class, nil), do: Keyword.merge(options, class: class)
  defp merge_class(options, nil, class), do: Keyword.merge(options, class: class)
  defp merge_class(options, a, b), do: Keyword.merge(options, class: "#{a} #{b}")
end
