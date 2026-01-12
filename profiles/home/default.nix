let
  myLib = import ../../lib;
in
{
  imports = myLib.importSubdirs ./.;
}
