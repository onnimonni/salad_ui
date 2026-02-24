defmodule Storybook.SaladUIComponents.Carousel do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Carousel

  def function, do: &Carousel.carousel/1

  def imports,
    do: [
      {Carousel,
       [
         carousel_content: 1,
         carousel_item: 1,
         carousel_previous: 1,
         carousel_next: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        description: "A basic carousel with 5 slides.",
        template: """
        <div class="w-full max-w-xs mx-auto px-16">
          <.carousel id="carousel-default">
            <.carousel_content>
              <.carousel_item>
                <div class="p-1">
                  <div class="flex aspect-square items-center justify-center rounded-lg border bg-card p-6">
                    <span class="text-4xl font-semibold">1</span>
                  </div>
                </div>
              </.carousel_item>
              <.carousel_item>
                <div class="p-1">
                  <div class="flex aspect-square items-center justify-center rounded-lg border bg-card p-6">
                    <span class="text-4xl font-semibold">2</span>
                  </div>
                </div>
              </.carousel_item>
              <.carousel_item>
                <div class="p-1">
                  <div class="flex aspect-square items-center justify-center rounded-lg border bg-card p-6">
                    <span class="text-4xl font-semibold">3</span>
                  </div>
                </div>
              </.carousel_item>
              <.carousel_item>
                <div class="p-1">
                  <div class="flex aspect-square items-center justify-center rounded-lg border bg-card p-6">
                    <span class="text-4xl font-semibold">4</span>
                  </div>
                </div>
              </.carousel_item>
              <.carousel_item>
                <div class="p-1">
                  <div class="flex aspect-square items-center justify-center rounded-lg border bg-card p-6">
                    <span class="text-4xl font-semibold">5</span>
                  </div>
                </div>
              </.carousel_item>
            </.carousel_content>
            <.carousel_previous />
            <.carousel_next />
          </.carousel>
        </div>
        """
      }
    ]
  end
end
