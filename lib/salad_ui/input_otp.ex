defmodule SaladUI.InputOTP do
  @moduledoc """
  One-time password input component with auto-advance and paste support.

  A hidden input captures all keyboard input while visual slots display
  individual characters.

  ## Examples:

      <.input_otp id="otp" max-length={6} on-complete={JS.push("verify_otp")}>
        <.input_otp_group>
          <.input_otp_slot index={0} />
          <.input_otp_slot index={1} />
          <.input_otp_slot index={2} />
        </.input_otp_group>
        <.input_otp_separator />
        <.input_otp_group>
          <.input_otp_slot index={3} />
          <.input_otp_slot index={4} />
          <.input_otp_slot index={5} />
        </.input_otp_group>
      </.input_otp>
  """
  use SaladUI, :component

  @doc """
  Renders the root input OTP component.

  ## Options

  * `:id` - Required unique identifier.
  * `:max-length` - Number of OTP characters. Defaults to `6`.
  * `:name` - Form field name.
  * `:value` - Current value.
  * `:pattern` - Regex pattern for allowed characters. Defaults to `"\\d"`.
  * `:on-complete` - Handler triggered when all slots are filled.
  * `:on-change` - Handler triggered on value change.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true
  attr :"max-length", :integer, default: 6
  attr :name, :string, default: nil
  attr :value, :string, default: ""
  attr :pattern, :string, default: "\\d"
  attr :"on-complete", :any, default: nil
  attr :"on-change", :any, default: nil
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_otp(assigns) do
    event_map =
      %{}
      |> add_event_mapping(assigns, "on-complete", :"on-complete")
      |> add_event_mapping(assigns, "on-change", :"on-change")

    assigns =
      assigns
      |> assign(:event_map, json(event_map))
      |> assign(:max_length, assigns[:"max-length"])

    ~H"""
    <div
      id={@id}
      data-component="input-otp"
      data-part="root"
      data-state="idle"
      data-max-length={@max_length}
      data-pattern={@pattern}
      data-event-mappings={@event_map}
      data-options={json(%{})}
      phx-hook="SaladUI"
      class={classes(["flex items-center gap-2 has-[:disabled]:opacity-50", @class])}
      {@rest}
    >
      <input
        data-part="hidden-input"
        type="text"
        inputmode="numeric"
        autocomplete="one-time-code"
        name={@name}
        value={@value}
        maxlength={@max_length}
        disabled={@disabled}
        class="sr-only absolute inset-0 opacity-0 pointer-events-none"
      />
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Groups OTP slots together visually.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_otp_group(assigns) do
    ~H"""
    <div class={classes(["flex items-center", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  An individual OTP slot that displays a single character.

  ## Options

  * `:index` - The slot index (0-based).
  """
  attr :index, :integer, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def input_otp_slot(assigns) do
    ~H"""
    <div
      data-part="slot"
      data-index={@index}
      data-active="false"
      data-filled="false"
      class={
        classes([
          "relative flex h-10 w-10 items-center justify-center border-y border-r text-sm transition-all first:rounded-l-md first:border-l last:rounded-r-md",
          "data-[active=true]:z-10 data-[active=true]:ring-2 data-[active=true]:ring-ring data-[active=true]:ring-offset-background",
          @class
        ])
      }
      {@rest}
    >
      <span data-part="slot-char" class="text-center"></span>
      <span
        data-part="slot-caret"
        hidden
        class="absolute inset-0 flex items-center justify-center pointer-events-none"
      >
        <span class="h-4 w-px animate-caret-blink bg-foreground duration-1000"></span>
      </span>
    </div>
    """
  end

  @doc """
  A visual separator between OTP groups (e.g. a dash).
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def input_otp_separator(assigns) do
    ~H"""
    <div role="separator" class={classes(["flex items-center", @class])} {@rest}>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        class="h-4 w-4"
      >
        <circle cx="12" cy="12" r="1" />
      </svg>
    </div>
    """
  end
end
