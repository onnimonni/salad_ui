defmodule SaladStorybookWeb.BrowserCase do
  @moduledoc """
  Test case for browser-based integration tests using Wallaby.
  Tests run against the storybook app to verify JS hooks work in a real browser.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Query
    end
  end

  setup do
    {:ok, session} = Wallaby.start_session()
    {:ok, session: session}
  end
end
