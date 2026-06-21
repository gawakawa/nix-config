{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "gwq";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "d-kuro";
    repo = "gwq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MfCYFbODWnfPxx+6sLlcMT6tqghgILHB13+ccYqVjBA=";
  };

  vendorHash = "sha256-4K01Xf1EXl/NVX1loQ76l1bW8QglBAQdvlZSo7J4NPI=";

  subPackages = [ "cmd/gwq" ];

  env.CGO_ENABLED = 0;

  meta = {
    description = "Git worktree manager with fuzzy finder, integrates with ghq";
    homepage = "https://github.com/d-kuro/gwq";
    license = lib.licenses.asl20;
    mainProgram = "gwq";
  };
})
