defmodule ExEffectiveBootstrap.Table do
  @moduledoc "Bootstrap table"

  use Phoenix.HTML

  @doc """
  Function for creating tables based on list data points.
  The table will have as many rows as there is elements in `data` list
  ```
  iex> table([:first_data_point, :second_data_point],
             ["Name"],
             [fn data_point -> inspect(data_point) end])
  <div class=\"table-responsive\">
    <table class=\"table\">
      <thead>
        <tr>
          <th>Name</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>:first_data_point</td>
        </tr>
        <tr>
          <td>:second_data_point</td>
        </tr>
      </tbody>
    </table>
  </div>
  ```
  The accessor function often works on maps and structs.
  If you only need to print the value under a key without any changes,
  you can use atom key as an accessor.
  ```
  iex> table([%{key: "value"}],
              ["Value"],
              [:key]) |> safe_to_string
  <div class=\"table-responsive\">
    <table class=\"table\">
      <thead>
        <tr>
          <th>Value</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>value</td>
        </tr>
      </tbody>
    </table>
  </div>
  ```

  If the accessor is neither fun nor atom, it is content id printed as is

  ```
  iex> table([%{key: "ignored"}],
             ["Totally unrelated to data"],
             ["Print it for every row"]) |> safe_to_string
  <div class=\"table-responsive\">
    <table class=\"table\">
      <thead>
        <tr>
          <th>Totally unrelated to data</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Print it for every row</td>
        </tr>
      </tbody>
    </table>
  </div>
  ```

  Sometimes, it is necessary to modify parent <td> or <th> tag for styling purposes.
  You can do that using `with_parent_attrs/2` helper.

  ```
  iex> table([%{key: "ignored"}],
             ["Totally unrelated to data" |> with_parent_attrs(class: "my-class")],
             ["Print it for every row" |> with_parent_attrs(class: "another")]) |> safe_to_string
  <div class=\"table-responsive\">
    <table class=\"table\">
      <thead>
        <tr>
          <th class="my-class">Totally unrelated to data</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class=\"another\">Print it for every row</td>
        </tr>
      </tbody>
    </table>
  </div>
  ```
  """
  def table(data, headers, accessors, opts \\ [])
      when is_list(data) and is_list(headers) and
             is_list(accessors) and length(headers) == length(accessors) do
    no_content_text = Keyword.get(opts, :no_content_text, "No content")

    if data == [] do
      content_tag(:p, no_content_text)
    else
      thead =
        headers
        |> Enum.map(fn header ->
          header
          |> wrap_content_tag(:th)
        end)
        |> wrap_content_tag(:tr)
        |> wrap_content_tag(:thead)

      tbody =
        data
        |> Enum.map(fn data_point ->
          accessors
          |> Enum.map(fn accessor ->
            accessor
            |> access(data_point)
            |> wrap_content_tag(:td)
          end)
          |> wrap_content_tag(:tr)
        end)
        |> wrap_content_tag(:tbody)

      tbody
      |> wrap_table(thead)
      |> wrap_table_responsive_div
    end
  end

  def with_parent_attrs(content, attrs),
    do: {:content_with_parent_attributes, content, attrs} |> IO.inspect()

  defp access(key, data_point) when is_atom(key) do
    Map.get(data_point, key, "")
  end

  defp access(fun, data_point) when is_function(fun, 1) do
    fun.(data_point) || ""
  end

  defp access(static_content, _data_point) do
    static_content
  end

  defp wrap_table(tbody, thead) do
    content_tag(:table, [thead, tbody], class: "table")
  end

  defp wrap_table_responsive_div(table) do
    content_tag(:div, [table], class: "table-responsive")
  end

  defp wrap_content_tag({:content_with_parent_attributes, content, attrs}, tag),
    do: content_tag(tag, content, attrs)

  defp wrap_content_tag(content, tag), do: content_tag(tag, content)
end
