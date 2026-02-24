defmodule Storybook.SaladUIComponents.Drawer do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Button
  alias SaladUI.Drawer

  def function, do: &Drawer.drawer/1

  def imports,
    do: [
      {Drawer,
       [
         drawer_trigger: 1,
         drawer_content: 1,
         drawer_header: 1,
         drawer_title: 1,
         drawer_description: 1,
         drawer_footer: 1,
         drawer_close: 1
       ]},
      {Button, [button: 1]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        description: "A drawer that slides up from the bottom.",
        template: """
        <.drawer id="drawer-default">
          <.drawer_trigger>
            <.button variant="outline">Open Drawer</.button>
          </.drawer_trigger>
          <.drawer_content>
            <.drawer_header>
              <.drawer_title>Move Goal</.drawer_title>
              <.drawer_description>Set your daily activity goal.</.drawer_description>
            </.drawer_header>
            <div class="p-4 pb-0">
              <div class="flex items-center justify-center space-x-2">
                <div class="flex-1 text-center">
                  <div class="text-7xl font-bold tracking-tighter">350</div>
                  <div class="text-[0.70rem] uppercase text-muted-foreground">Calories/day</div>
                </div>
              </div>
            </div>
            <.drawer_footer>
              <.button>Submit</.button>
              <.drawer_close>
                <.button variant="outline" class="w-full">Cancel</.button>
              </.drawer_close>
            </.drawer_footer>
          </.drawer_content>
        </.drawer>
        """
      }
    ]
  end
end
