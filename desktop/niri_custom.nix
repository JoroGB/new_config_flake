{ pkgs, inputs, ... }:
{
    # niri desde home manager / modulo para home-manager
    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        # ...
        spawn-at-startup = [
          {
            command = [
              "noctalia-shell"
            ];
          }
        ];
      };
    };
}
