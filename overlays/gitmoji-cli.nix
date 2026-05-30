_: final: prev: {
  gitmoji-cli = prev.gitmoji-cli.override {
    nodejs = final.nodejs_24;
  };
}
