{ inputs, ... }:

{
  imports = [
    inputs.srvos.nixosModules.mixins-nginx
    inputs.srvos.nixosModules.hardware-hetzner-online-amd
    ./nixpkgs-update.nix
    ./nixpkgs-update-backup.nix
    inputs.self.nixosModules.common
    inputs.self.nixosModules.hercules-ci
    inputs.self.nixosModules.raid
    inputs.self.nixosModules.zfs
    inputs.self.nixosModules.remote-builder-build04
    inputs.self.nixosModules.remote-builder-darwin02
    inputs.self.nixosModules.remote-builder-darwin03
  ];

  # /boot is a mirror raid
  boot.loader.grub.devices = [ "/dev/nvme0n1" "/dev/nvme1n1" ];
  boot.loader.grub.enable = true;

  networking.hostName = "build02";
  networking.hostId = "af9ccc71";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  systemd.network.networks."10-uplink".networkConfig.Address = "2a01:4f9:4a:2b02::1/64";

  system.stateVersion = "20.09";
}
