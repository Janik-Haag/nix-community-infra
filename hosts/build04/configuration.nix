{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    inputs.self.nixosModules.common
    inputs.self.nixosModules.hercules-ci
    inputs.self.nixosModules.remote-builder-user
  ];

  nixpkgs.system = "aarch64-linux";

  # disable kvm/nixos-tests
  nix.settings.system-features = [ "big-parallel" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = false;

  # Make it easier to recover via serial console in case something goes wrong.
  services.getty.autologinUser = "root";

  networking.hostName = "build04";
  networking.hostId = "8daf74c0";

  system.stateVersion = "21.11";
  systemd.network = {
    enable = true;
    networks.ethernet.extraConfig = ''
      [Match]
      Type = ether
      [Network]
      DHCP = yes
      IPv6AcceptRA = true
      # Usually dhcpv6 should give us a public address, but it doesn't seem to work for oracle with both networkd/dhcpcd
      # so we set it manually here. One can get the address by clicking on the primary vnic in the oracle console and
      # under Resources -> IPv6 Addresses
      Address = 2603:c022:c001:b500:f1d4:5343:e8ce:d6ba
    '';
  };
}

## `opc` is the username from the oracle image. Replace with root if we are booted into nixos.
# nix run github:numtide/nixos-anywhere#nixos-anywhere -- \
#   --debug \
#   --kexec "$(nix build --print-out-paths github:nix-community/nixos-images#packages.aarch64-linux.kexec-installer-nixos-unstable)/nixos-kexec-installer-aarch64-linux.tar.gz" \
#   --flake '.#build04' \
#   opc@141.148.235.248
