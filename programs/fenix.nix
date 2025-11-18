{pkgs, inputs, ...}:
let
  # imports = [
    # inputs.fenix
  # ];
    # Select the desired rust toolchain from fenix
    rustToolchain = inputs.fenix.packages.x86_64-linux.complete.toolchain;
    # (adjust the system architecture as needed, e.g., aarch64-darwin)
  in {
    home.packages = [
      rustToolchain
      # You can also add other packages
      ];
    }
