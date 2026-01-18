{ pkgs, ... }:
{
  home.packages = [ pkgs.claude-code-router ];

  home.file.".claude-code-router/config.json".text = builtins.toJSON {
    providers = [
      {
        name = "openrouter";
        api_endpoint = "https://openrouter.ai/api/v1";
        api_key = "$OPENROUTER_API_KEY";
      }
    ];
    router = {
      default = "anthropic/claude-opus-4-5-20251101";
    };
  };
}
