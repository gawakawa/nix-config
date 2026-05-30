let
  myLib = import ../lib;
in
map import (myLib.importSubdirs ./.)
