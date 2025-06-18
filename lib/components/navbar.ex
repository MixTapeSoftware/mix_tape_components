defmodule MixTape.Components.Navbar do
  @moduledoc """
  A flexible navbar component using CVA (Class Variance Authority).

  The navbar component provides a responsive container for navigation elements with customizable
  size, background shade, shadow effects, and content alignment options.

  ## Basic Usage

  The simplest navbar with default styling:

      <.page_navbar>
        <div class="flex items-center gap-4">
          <h1 class="text-xl font-bold">My App</h1>
          <nav class="flex gap-2">
            <.link navigate={~p"/"}>Home</.link>
            <.link navigate={~p"/about"}>About</.link>
          </nav>
        </div>
      </.page_navbar>

  ## Logo and Navigation

  A typical navbar with logo, navigation links, and user actions:

      <.page_navbar size="lg" shade="medium" shadow="lg">
        <div class="flex justify-between items-center px-6 w-full">
          <div class="flex items-center gap-6">
            <img src="/images/logo.svg" alt="Logo" class="h-8" />
            <nav class="flex gap-4">
              <.link class="hover:text-primary" navigate={~p"/dashboard"}>
                Dashboard
              </.link>
              <.link class="hover:text-primary" navigate={~p"/projects"}>
                Projects
              </.link>
              <.link class="hover:text-primary" navigate={~p"/settings"}>
                Settings
              </.link>
            </nav>
          </div>
          <div class="flex items-center gap-4">
            <.button variant="ghost" size="sm">
              <.icon name="hero-bell" class="h-5 w-5" />
            </.button>
            <.dropdown>
              <:trigger>
                <.avatar src={@current_user.avatar} size="sm" />
              </:trigger>
              <:item>
                <.link navigate={~p"/profile"}>Profile</.link>
              </:item>
              <:item>
                <.link method="delete" href={~p"/logout"}>Logout</.link>
              </:item>
            </.dropdown>
          </div>
        </div>
      </.page_navbar>

  ## Centered Content

  For landing pages or marketing sites:

      <.page_navbar
        size="xl"
        shade="dark"
        shadow="xl"
        centering="centered_full"
      >
        <div class="flex flex-col gap-2 text-center">
          <h1 class="text-3xl font-bold text-primary">Welcome to MixTape</h1>
          <p class="text-base-content/70">Your music, your way</p>
        </div>
      </.page_navbar>

  ## With Search Bar

  Navbar with integrated search functionality:

      <.page_navbar shade="light" shadow="sm">
        <div class="flex justify-between items-center px-4 w-full">
          <h2 class="text-lg font-semibold">Products</h2>
          <div class="flex items-center gap-4">
            <form class="relative">
              <input
                type="search"
                placeholder="Search products..."
                class="input input-bordered input-sm pr-10"
              />
              <button type="submit" class="absolute right-2 top-1/2 -translate-y-1/2">
                <.icon name="hero-magnifying-glass" class="h-4 w-4" />
              </button>
            </form>
            <.button size="sm" variant="primary">
              <.icon name="hero-plus" class="h-4 w-4" />
              Add Product
            </.button>
          </div>
        </div>
      </.page_navbar>

  ## Mobile Responsive

  Navbar with mobile menu toggle:

      <.page_navbar size="md" shade="medium">
        <div class="flex justify-between items-center px-4 w-full">
          <h1 class="font-bold">Brand</h1>

          <!-- Desktop Navigation -->
          <nav class="hidden md:flex gap-4">
            <.link navigate={~p"/"}>Home</.link>
            <.link navigate={~p"/features"}>Features</.link>
            <.link navigate={~p"/pricing"}>Pricing</.link>
          </nav>

          <!-- Mobile Menu Button -->
          <button class="md:hidden" phx-click="toggle-mobile-menu">
            <.icon name="hero-bars-3" class="h-6 w-6" />
          </button>
        </div>
      </.page_navbar>

  ## Available Variants

  ### Size
  Controls the height of the navbar and bottom margin:
  - `:xs` - Compact navbar (h-10, mb-3)
  - `:sm` - Small navbar (h-12, mb-6)
  - `:md` - Medium navbar (h-14, mb-8) - Default
  - `:lg` - Large navbar (h-16, mb-10)
  - `:xl` - Extra large navbar (h-20, mb-12)

  ### Shade
  Controls the background color:
  - `:light` - Light background (bg-base-100) - Default
  - `:medium` - Medium background (bg-base-200)
  - `:dark` - Dark background (bg-base-300)

  ### Shadow
  Controls the shadow depth:
  - `:none` - No shadow
  - `:sm` - Small shadow
  - `:md` - Medium shadow - Default
  - `:lg` - Large shadow
  - `:xl` - Extra large shadow

  ### Centering
  Controls content alignment:
  - `:none` - No alignment styling
  - `:vertical_only` - Centers content vertically - Default
  - `:centered_full` - Centers content both vertically and horizontally

  ## Attributes

  - Global attributes are forwarded to the outer div element

  ## Slots

  - `inner_block` - The navbar content. Structure this as needed for your layout.
  """
  use CVA.Component
  use Phoenix.Component

  variant(
    :size,
    [
      xs: "h-10 w-full mb-3",
      sm: "h-12 w-full mb-6",
      md: "h-14 w-full mb-8",
      lg: "h-16 w-full mb-10",
      xl: "h-20 w-full mb-12"
    ],
    default: :md
  )

  variant(
    :shade,
    [
      dark: "bg-base-300",
      medium: "bg-base-200",
      light: "bg-base-100"
    ],
    default: :light
  )

  variant(
    :shadow,
    [
      none: "shadow-none",
      sm: "shadow-sm",
      md: "shadow-md",
      lg: "shadow-lg",
      xl: "shadow-xl"
    ],
    default: :md
  )

  variant(
    :centering,
    [
      centered_full: "[&>nav]:items-center [&>nav]:justify-center",
      vertical_only: "[&>nav]:items-center",
      none: ""
    ],
    default: :vertical_only
  )

  attr(:rest, :global)

  slot(:inner_block, doc: "Single content slot (alternative to start/center/end)")

  def page_navbar(assigns) do
    ~H"""
    <div class={@cva_class} {@rest}>
      <nav class="h-full flex">
        {render_slot(@inner_block)}
      </nav>
    </div>
    """
  end
end
