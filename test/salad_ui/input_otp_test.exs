defmodule SaladUI.InputOTPTest do
  use ComponentCase

  import SaladUI.InputOTP

  describe "input_otp/1" do
    test "renders OTP input with slots" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_otp id="otp-test" max-length={6}>
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
        """)

      assert html =~ ~s(id="otp-test")
      assert html =~ ~s(data-component="input-otp")
      assert html =~ ~s(phx-hook="SaladUI")
      assert html =~ ~s(data-max-length="6")
      assert html =~ ~s(inputmode="numeric")
      assert html =~ ~s(autocomplete="one-time-code")
      # 6 slots
      assert count_substring(html, ~s(data-part="slot")) == 6
    end

    test "renders separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_otp_separator />
        """)

      assert html =~ ~s(role="separator")
    end

    test "renders with name for forms" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_otp id="otp-form" name="verification_code" max-length={4}>
          <.input_otp_group>
            <.input_otp_slot index={0} />
            <.input_otp_slot index={1} />
            <.input_otp_slot index={2} />
            <.input_otp_slot index={3} />
          </.input_otp_group>
        </.input_otp>
        """)

      assert html =~ ~s(name="verification_code")
    end
  end
end
