{ fetchFromGitHub }:
rec {
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "cordx56";
    repo = "rustowl";
    rev = "v${version}";
    hash = "sha256-ULjCCcU1wFfFrRmjky3E25WD0YN7ighSPLj36PqSUG8=";
  };
}
