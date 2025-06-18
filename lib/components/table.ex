defmodule MixTape.Components.Table do
  @moduledoc """
  A flexible table component built with CVA (Class Variance Authority).

  ## Basic Usage

  The simplest table requires an `id`, `rows` list, and column definitions:

      <.table id="users-table" rows={@users}>
        <:col :let={user} label="Name">
          {user.name}
        </:col>
        <:col :let={user} label="Email">
          {user.email}
        </:col>
        <:col :let={user} label="Role">
          {user.role}
        </:col>
      </.table>

  ## With Actions

  Add an actions column for row-specific operations:

      <.table
        id="products-table"
        rows={@products}
        header_bg={:primary}
        row_bg={:striped}
      >
        <:col :let={product} label="Name">
          {product.name}
        </:col>
        <:col :let={product} label="Price">
          ${product.price}
        </:col>
        <:action :let={product}>
          <.link patch={~p"/products/\#{product.id}/edit"} class="btn btn-sm btn-ghost">
            Edit
          </.link>
          <.button phx-click="delete" phx-value-id={product.id} class="btn btn-sm btn-error">
            Delete
          </.button>
        </:action>
      </.table>

  ## Styled Table

  Create visually appealing tables with background colors and effects:

      <.table
        id="orders-table"
        rows={@orders}
        header_bg={:secondary}
        row_bg={:hover_stripe}
        border={:shadow}
        spacing={:comfortable}
        hover={:highlight}
      >
        <:col :let={order} label="Order #">
          #\{order.number}
        </:col>
        <:col :let={order} label="Customer">
          {order.customer_name}
        </:col>
        <:col :let={order} label="Total" align="right">
          ${order.total}
        </:col>
        <:col :let={order} label="Status">
          <span class={status_badge_class(order.status)}>
            {order.status}
          </span>
        </:col>
      </.table>

  ## Interactive Table

  Make tables interactive with clickable rows and selection:

      <.table
        id="tasks-table"
        rows={@tasks}
        selectable={true}
        row_click={JS.navigate(~p"/tasks/\#{&1.id}")}
        row_id={& &1.id}
        header_bg={:neutral}
        row_bg={:white}
        hover={:row}
      >
        <:col :let={task} label="Title">
          {task.title}
        </:col>
        <:col :let={task} label="Assignee">
          {task.assignee.name}
        </:col>
        <:col :let={task} label="Due Date">
          {format_date(task.due_date)}
        </:col>
      </.table>

  ## Empty State

  Handle empty data gracefully:

      <.table
        id="notifications-table"
        rows={@notifications}
        empty_message="No notifications yet"
      >
        <:col :let={notification} label="Message">
          {notification.message}
        </:col>
        <:empty_state>
          <div class="flex flex-col items-center gap-4 py-8">
            <.icon name="hero-bell-slash" class="h-12 w-12 text-base-300" />
            <p class="text-base-content/60">You're all caught up!</p>
            <.button size="sm">Refresh</.button>
          </div>
        </:empty_state>
      </.table>

  ## Available Variants

  ### Visual Styling
  - `header_bg`: `:none | :primary | :secondary | :accent | :neutral | :base_100 | :base_200 | :base_300 | :success | :warning | :error | :info`
  - `row_bg`: `:none | :white | :base_100 | :base_200 | :base_300 | :striped | :hover_stripe`
  - `border`: `:none | :default | :rounded | :shadow | :shadow_sm | :shadow_xl`
  - `hover`: `:none | :row | :cell | :highlight`

  ### Layout
  - `size`: `:xs | :sm | :md | :lg` - Controls text size
  - `spacing`: `:compact | :normal | :comfortable | :spacious` - Controls padding
  - `dividers`: `:none | :horizontal | :all | :vertical | :full` - Controls divider lines
  - `align`: `:left | :center | :right` - Default alignment for all cells

  ### Behavior
  - `loading`: Boolean - Shows loading state
  - `selectable`: Boolean - Adds selection checkboxes
  - `row_click`: JS command - Makes rows clickable
  - `row_id`: Function - Generates unique row IDs

  ## Attributes

  - `id` (required) - Unique identifier for the table
  - `rows` (required) - List of data to display
  - `empty_message` - Message shown when no data (default: "No data available")
  - Global attributes are forwarded to the table element

  ## Slots

  - `col` (required) - Define columns with `:label`, `:class`, and `:align` options
  - `action` - Optional actions column
  - `empty_state` - Custom empty state content
  """
  use CVA.Component
  use Phoenix.Component

  variant(
    :variant,
    [
      default: "table-auto w-full",
      compact: "table-compact w-full",
      fixed: "table-fixed w-full"
    ],
    default: :default
  )

  variant(
    :size,
    [
      xs: "table-xs text-xs",
      sm: "table-sm text-sm",
      md: "table-md text-base",
      lg: "table-lg text-lg"
    ],
    default: :md
  )

  variant(
    :header_bg,
    [
      none: "",
      primary: "[&_thead]:bg-primary [&_thead]:text-primary-content",
      secondary: "[&_thead]:bg-secondary [&_thead]:text-secondary-content",
      accent: "[&_thead]:bg-accent [&_thead]:text-accent-content",
      neutral: "[&_thead]:bg-neutral [&_thead]:text-neutral-content",
      base_100: "[&_thead]:bg-base-100",
      base_200: "[&_thead]:bg-base-200",
      base_300: "[&_thead]:bg-base-300",
      success: "[&_thead]:bg-success [&_thead]:text-success-content",
      warning: "[&_thead]:bg-warning [&_thead]:text-warning-content",
      error: "[&_thead]:bg-error [&_thead]:text-error-content",
      info: "[&_thead]:bg-info [&_thead]:text-info-content"
    ],
    default: :base_200
  )

  variant(
    :row_bg,
    [
      none: "",
      white: "[&_tbody]:bg-white",
      base_100: "[&_tbody]:bg-base-100",
      base_200: "[&_tbody]:bg-base-200",
      base_300: "[&_tbody]:bg-base-300",
      primary: "[&_tbody]:bg-primary [&_tbody]:text-primary-content",
      secondary: "[&_tbody]:bg-secondary [&_tbody]:text-secondary-content",
      accent_light: "[&_tbody]:bg-accent/10",
      primary_light: "[&_tbody]:bg-primary/10",
      secondary_light: "[&_tbody]:bg-secondary/10",
      striped: "[&_tbody_tr:nth-child(even)]:bg-base-200/50",
      striped_strong: "[&_tbody_tr:nth-child(even)]:bg-base-300",
      hover_stripe:
        "[&_tbody_tr:hover]:bg-base-200/50 [&_tbody_tr:nth-child(even)]:bg-base-200/30 [&_tbody_tr:nth-child(even):hover]:bg-base-200/70"
    ],
    default: :base_100
  )

  variant(
    :border,
    [
      none: "",
      default: "border border-base-300",
      rounded: "rounded-lg overflow-hidden border border-base-300",
      shadow: "shadow-lg ring-1 ring-black/5 rounded-lg overflow-hidden",
      shadow_sm: "shadow-sm rounded-lg overflow-hidden border border-base-200",
      shadow_xl: "shadow-xl ring-2 ring-black/10 rounded-xl overflow-hidden"
    ],
    default: :default
  )

  variant(
    :hover,
    [
      none: "",
      row:
        "[&_tbody_tr]:transition-colors [&_tbody_tr]:cursor-pointer [&_tbody_tr:hover]:bg-base-200/50",
      cell: "[&_tbody_td]:transition-colors [&_tbody_td:hover]:bg-base-200/50",
      highlight:
        "[&_tbody_tr]:transition-all [&_tbody_tr:hover]:bg-primary/10 [&_tbody_tr:hover]:shadow-sm"
    ],
    default: :none
  )

  variant(
    :spacing,
    [
      compact: "[&_th]:px-2 [&_th]:py-1 [&_td]:px-2 [&_td]:py-1",
      normal: "[&_th]:px-4 [&_th]:py-2 [&_td]:px-4 [&_td]:py-2",
      comfortable: "[&_th]:px-4 [&_th]:py-3 [&_td]:px-4 [&_td]:py-3",
      spacious: "[&_th]:px-6 [&_th]:py-3.5 [&_td]:px-6 [&_td]:py-4"
    ],
    default: :normal
  )

  variant(
    :dividers,
    [
      none: "",
      horizontal:
        "[&_thead_tr]:border-b [&_thead_tr]:border-base-300 [&_tbody_tr:not(:last-child)]:border-b [&_tbody_tr]:border-base-200",
      all:
        "[&_thead_tr]:border-b [&_thead_tr]:border-base-300 [&_tbody_tr]:border-b [&_tbody_tr]:border-base-200",
      vertical:
        "[&_tr>th:not(:last-child)]:border-r [&_tr>td:not(:last-child)]:border-r [&_tr>*]:border-base-200",
      full:
        "[&_thead_tr]:border-b [&_thead_tr]:border-base-300 [&_tbody_tr]:border-b [&_tr>th:not(:last-child)]:border-r [&_tr>td:not(:last-child)]:border-r [&_tr>*]:border-base-200"
    ],
    default: :horizontal
  )

  variant(
    :align,
    [
      left: "[&_th]:text-left [&_td]:text-left",
      center: "[&_th]:text-center [&_td]:text-center",
      right: "[&_th]:text-right [&_td]:text-right"
    ],
    default: :left
  )

  attr(:id, :string, required: true)
  attr(:rows, :list, required: true)
  attr(:row_click, JS, default: nil)
  attr(:row_id, :any, default: nil, doc: "Function to generate row ID from row data")
  attr(:empty_message, :string, default: "No data available")
  attr(:loading, :boolean, default: false)
  attr(:selectable, :boolean, default: false)
  attr(:rest, :global)

  slot :col, required: true do
    attr(:label, :string)
    attr(:class, :string)
    attr(:align, :string)
  end

  slot :action do
    attr(:label, :string)
  end

  slot(:empty_state)

  def table(assigns) do
    assigns = assign(assigns, :has_actions, assigns.action != [])

    ~H"""
    <div class="w-full overflow-x-auto">
      <table id={@id} class={@cva_class} {@rest}>
        <thead>
          <tr>
            <th :if={@selectable} class="w-10 px-4">
              <input type="checkbox" class="checkbox checkbox-sm" phx-click="select-all" />
            </th>
            <th
              :for={{col, index} <- Enum.with_index(@col)}
              class={[
                "font-semibold",
                col[:class],
                col[:align] && "text-#{col[:align]}"
              ]}
              id={"#{@id}-col-#{index}"}
            >
              {col[:label]}
            </th>
            <th :if={@has_actions} class="text-right font-semibold">
              <span class="sr-only">{@action[:label] || "Actions"}</span>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr :if={@loading} class="h-32">
            <td
              colspan={
                length(@col) + if(@selectable, do: 1, else: 0) + if @has_actions, do: 1, else: 0
              }
              class="text-center"
            >
              <span class="loading loading-spinner loading-md"></span>
              <span class="ml-2">Loading...</span>
            </td>
          </tr>
          <tr :if={!@loading && @rows == []} class="h-32">
            <td
              colspan={
                length(@col) + if(@selectable, do: 1, else: 0) + if @has_actions, do: 1, else: 0
              }
              class="text-center text-base-content/60"
            >
              {render_slot(@empty_state) || @empty_message}
            </td>
          </tr>
          <tr
            :for={{row, row_index} <- Enum.with_index(@rows)}
            :if={!@loading}
            id={(@row_id && @row_id.(row)) || "#{@id}-row-#{row_index}"}
            phx-click={@row_click}
            phx-value-id={@row_id && @row_id.(row)}
            class={@row_click && "cursor-pointer"}
          >
            <td :if={@selectable} class="w-10 px-4">
              <input
                type="checkbox"
                class="checkbox checkbox-sm"
                phx-click="select-row"
                phx-value-id={@row_id && @row_id.(row)}
              />
            </td>
            <td
              :for={{col, col_index} <- Enum.with_index(@col)}
              class={[
                col[:class],
                col[:align] && "text-#{col[:align]}"
              ]}
            >
              {render_slot(col, row)}
            </td>
            <td :if={@has_actions} class="text-right">
              <div class="flex items-center justify-end gap-2">
                {render_slot(@action, row)}
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
