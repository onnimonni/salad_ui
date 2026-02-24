defmodule Storybook.SaladUIComponents.NavigationMenu do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.NavigationMenu

  def function, do: &NavigationMenu.navigation_menu/1

  def imports,
    do: [
      {NavigationMenu,
       [
         navigation_menu_list: 1,
         navigation_menu_item: 1,
         navigation_menu_trigger: 1,
         navigation_menu_content: 1,
         navigation_menu_link: 1,
         navigation_menu_indicator: 1,
         navigation_menu_viewport: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        description: "Navigation menu with hover-activated content panels.",
        template: """
        <.navigation_menu id="nav-default">
          <.navigation_menu_list>
            <.navigation_menu_item>
              <.navigation_menu_trigger>Getting Started</.navigation_menu_trigger>
              <.navigation_menu_content>
                <ul class="grid gap-3 p-4 md:w-[400px] lg:w-[500px] lg:grid-cols-[.75fr_1fr]">
                  <li class="row-span-3">
                    <.navigation_menu_link href="/" class="flex h-full w-full select-none flex-col justify-end rounded-md bg-gradient-to-b from-muted/50 to-muted p-6 no-underline outline-none focus:shadow-md">
                      <div class="mb-2 mt-4 text-lg font-medium">SaladUI</div>
                      <p class="text-sm leading-tight text-muted-foreground">
                        Beautifully designed components built with Phoenix LiveView.
                      </p>
                    </.navigation_menu_link>
                  </li>
                  <li>
                    <.navigation_menu_link href="/docs">
                      <div class="text-sm font-medium leading-none">Introduction</div>
                      <p class="line-clamp-2 text-sm leading-snug text-muted-foreground">
                        Re-usable components built with Phoenix LiveView.
                      </p>
                    </.navigation_menu_link>
                  </li>
                  <li>
                    <.navigation_menu_link href="/docs/installation">
                      <div class="text-sm font-medium leading-none">Installation</div>
                      <p class="line-clamp-2 text-sm leading-snug text-muted-foreground">
                        How to install dependencies and structure your app.
                      </p>
                    </.navigation_menu_link>
                  </li>
                </ul>
              </.navigation_menu_content>
            </.navigation_menu_item>
            <.navigation_menu_item>
              <.navigation_menu_trigger>Components</.navigation_menu_trigger>
              <.navigation_menu_content>
                <ul class="grid w-[400px] gap-3 p-4 md:w-[500px] md:grid-cols-2 lg:w-[600px]">
                  <li>
                    <.navigation_menu_link href="/docs/components/button">
                      <div class="text-sm font-medium leading-none">Button</div>
                      <p class="line-clamp-2 text-sm leading-snug text-muted-foreground">
                        Interactive button with multiple variants.
                      </p>
                    </.navigation_menu_link>
                  </li>
                  <li>
                    <.navigation_menu_link href="/docs/components/dialog">
                      <div class="text-sm font-medium leading-none">Dialog</div>
                      <p class="line-clamp-2 text-sm leading-snug text-muted-foreground">
                        Modal dialogs and confirmations.
                      </p>
                    </.navigation_menu_link>
                  </li>
                </ul>
              </.navigation_menu_content>
            </.navigation_menu_item>
            <.navigation_menu_item>
              <.navigation_menu_link href="/docs">Documentation</.navigation_menu_link>
            </.navigation_menu_item>
          </.navigation_menu_list>
          <.navigation_menu_viewport />
        </.navigation_menu>
        """
      }
    ]
  end
end
