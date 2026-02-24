{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/languages/
  languages.elixir = {
    enable = true;
    package = pkgs.beam27Packages.elixir_1_19;
  };

  languages.erlang = {
    enable = true;
    package = pkgs.beam27Packages.erlang;
  };

  # Rust for the eg thin client
  languages.rust.enable = true;

  # Zig is required by Burrito for cross-compilation
  packages = [
    pkgs.zig
    pkgs.biome
    pkgs.chromedriver
  ];

  # Dev scripts for running checks
  scripts.lint-js.exec = "cd $DEVENV_ROOT/assets && npx biome check salad_ui/";
  scripts.lint-js.description = "Lint JS with Biome";
  scripts.typecheck-js.exec = "cd $DEVENV_ROOT/assets && npx tsc --noEmit -p jsconfig.json";
  scripts.typecheck-js.description = "Type check JS with tsc";
  scripts.test-js.exec = "cd $DEVENV_ROOT/assets && npx vitest run";
  scripts.test-js.description = "Run JS unit tests (Vitest)";
  scripts.test-browser.exec = "cd $DEVENV_ROOT/storybook && mix test test/browser/";
  scripts.test-browser.description = "Run Wallaby browser tests against storybook";

  claude.code.enable = true;

  # Browser automation for testing
  claude.code.mcpServers.playwright = {
    type = "stdio";
    command = "bunx";
    args = [ "@playwright/mcp@latest" ];
  };

  # Gemini UX review via consult-llm-mcp (requires GEMINI_API_KEY env var)
  # System prompt configured in ~/.consult-llm-mcp/SYSTEM_PROMPT.md
  claude.code.mcpServers.consult-llm = {
    type = "stdio";
    command = "bunx";
    args = [
      "-y"
      "consult-llm-mcp"
    ];
    env = {
      CONSULT_LLM_DEFAULT_MODEL = "gemini-3.1-pro-preview";
      CONSULT_LLM_ALLOWED_MODELS = "gemini-3.1-pro-preview";
    };
  };
}
