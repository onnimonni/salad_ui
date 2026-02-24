defmodule Storybook.SaladUIComponents.InputOTP do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.InputOTP

  def function, do: &InputOTP.input_otp/1

  def imports,
    do: [
      {InputOTP,
       [
         input_otp_group: 1,
         input_otp_slot: 1,
         input_otp_separator: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        description: "6-digit OTP input with groups separated by a dot.",
        template: """
        <.input_otp id="otp-default" max-length={6}>
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
      },
      %Variation{
        id: :four_digit,
        description: "4-digit OTP input without separator.",
        template: """
        <.input_otp id="otp-four" max-length={4}>
          <.input_otp_group>
            <.input_otp_slot index={0} />
            <.input_otp_slot index={1} />
            <.input_otp_slot index={2} />
            <.input_otp_slot index={3} />
          </.input_otp_group>
        </.input_otp>
        """
      }
    ]
  end
end
