defmodule ExEffectiveBootstrap.FlashAlert do
  @moduledoc "Bootstrap alerts for phoenix flash messages"
  use Phoenix.HTML

  @doc """
  Creates a bootstrap alert for each flash message in the conn

  Examples:

  <%= flash_alert(@conn) %>
  """
  @spec flash_alert(Plug.Conn.t()) :: Phoenix.HTML.Safe.t() | nil
  def flash_alert(conn) do
    flash = Phoenix.Controller.get_flash(conn)

    if map_size(flash) > 0 do
      content_tag(:div, class: "row") do
        content_tag(:div, class: "col") do
          Enum.map(flash, fn {type, message} -> alert(convert(type), message) end)
        end
      end
    end
  end

  @doc """
  Bootstrap Alert
  Creates a dismissable alert with the given type and content

  Examples:

  <%= alert(:danger, "This is bad") %>
  <%= alert(:success, "This is good") %>
  """
  @spec alert(atom | String.t(), String.t()) :: Phoenix.HTML.Safe.t()
  def alert(type, content) do
    button_opts = [class: "close", type: "button", "data-dismiss": "alert", "aria-label": "Close"]

    content_tag(:div, class: "alert alert-dismissible alert-#{type} fade show", role: "alert") do
      button = content_tag(:button, button_opts) do
        content_tag(:span, {:safe, "&times;"}, "aria-hidden": "true")
      end

      [content, button]
    end
  end

  defp convert(class) do
    case class do
      "error" -> "danger"
      _ -> class
    end
  end
end
