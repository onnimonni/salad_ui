defmodule SaladUI.FormTest do
  use ComponentCase

  import SaladUI.Button
  import SaladUI.Form
  import SaladUI.Input

  describe "Test form components" do
    test "It renders form item correctly" do
      assigns = %{}

      html =
        ~H"""
        <.form_item>We are inside form item</.form_item>
        """
        |> rendered_to_string()
        |> clean_string()

      assert html =~ "<div class=\"space-y-2\">We are inside form item</div>"
    end

    test "It renders form label_correctly" do
      assigns = %{}

      html =
        ~H"""
        <.form_label>This is a label</.form_label>
        """
        |> rendered_to_string()
        |> clean_string()

      for class <- ~w(font-medium leading-none text-sm peer-disabled:cursor-not-allowed peer-disabled:opacity-70) do
        assert html =~ class
      end

      assert html =~ "This is a label"
    end

    test "It renders form_control" do
      assigns = %{}

      html =
        ~H"""
        <.form_control>Form control</.form_control>
        """
        |> rendered_to_string()
        |> clean_string()

      assert html =~ "Form control"
    end

    test "It renders form_description correctly" do
      assigns = %{}

      html =
        ~H"""
        <.form_description>This is a form description</.form_description>
        """
        |> rendered_to_string()
        |> clean_string()

      assert html == "<p class=\"text-muted-foreground text-sm\">This is a form description</p>"
    end

    test "It renders form message correctly" do
      assigns = %{}

      html =
        ~H"""
        <.form_message>This is a form message</.form_message>
        """
        |> rendered_to_string()
        |> clean_string()

      for class <- ~w(text-destructive font-medium text-sm) do
        assert html =~ class
      end

      assert html =~ "This is a form message"
    end

    test "It renders an entire form correctly" do
      assigns = %{form: %{}, myself: "test-string"}

      html =
        ~H"""
        <.form
          class="space-y-6"
          for={@form}
          id="project-form"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >
          <.form_item>
            <.form_label>What is your project's name?</.form_label>

            <.form_control>
              <.input field={@form[:name]} type="text" phx-debounce="500" />
            </.form_control>

            <.form_description>This is your public display name.</.form_description>
            <.form_message field={@form[:name]} />
          </.form_item>

          <div class="w-full flex flex-row-reverse">
            <.button class="btn btn-secondary btn-md" icon="inbox_arrow_down" phx-disable-with="Saving...">
              Save project
            </.button>
          </div>
        </.form>
        """
        |> rendered_to_string()
        |> clean_string()

      assert String.contains?(html, "class=\"space-y-6\"")
      assert String.contains?(html, "id=\"project-form\"")
      assert String.contains?(html, "phx-change=\"validate\"")
      assert String.contains?(html, "phx-submit=\"save\"")
      assert String.contains?(html, "phx-target=\"test-string\"")

      for class <- ~w(font-medium leading-none text-sm peer-disabled:cursor-not-allowed peer-disabled:opacity-70) do
        assert html =~ class
      end

      assert html =~ "What is your project's name?"

      assert html =~ "<p class=\"text-muted-foreground text-sm\">This is your public display name.</p>"
      assert html =~ "Save project</button>"
      assert html =~ "</div></form>"
    end
  end

  describe "fieldset/1" do
    test "renders a fieldset element" do
      assigns = %{}

      html =
        ~H"""
        <.fieldset>
          <.field_legend>Personal Info</.field_legend>
        </.fieldset>
        """
        |> rendered_to_string()
        |> clean_string()

      assert html =~ "<fieldset"
      assert html =~ "space-y-4"
      assert html =~ "Personal Info"
    end
  end

  describe "field_legend/1" do
    test "renders a legend element" do
      assigns = %{}

      html =
        ~H"""
        <.field_legend>Account Details</.field_legend>
        """
        |> rendered_to_string()
        |> clean_string()

      assert html =~ "<legend"
      assert html =~ "font-semibold"
      assert html =~ "Account Details"
    end
  end

  describe "field_group/1" do
    test "renders vertical field group" do
      assigns = %{}

      html =
        ~H"""
        <.field_group>
          <div>Field 1</div>
          <div>Field 2</div>
        </.field_group>
        """
        |> rendered_to_string()
        |> clean_string()

      assert html =~ "flex-col"
      assert html =~ "gap-4"
    end

    test "renders horizontal field group" do
      assigns = %{}

      html =
        ~H"""
        <.field_group orientation="horizontal">
          <div>Field 1</div>
          <div>Field 2</div>
        </.field_group>
        """
        |> rendered_to_string()
        |> clean_string()

      assert html =~ "flex-row"
      assert html =~ "items-start"
    end
  end

  describe "field_separator/1" do
    test "renders a separator" do
      assigns = %{}

      html =
        ~H"""
        <.field_separator />
        """
        |> rendered_to_string()
        |> clean_string()

      assert html =~ "role=\"separator\""
      assert html =~ "bg-border"
    end
  end
end
