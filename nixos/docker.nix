{...}: {
  boot.kernel.sysctl."vm.max_map_count" = 262144;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    daemon.settings.default-ulimits.nofile = {
      Hard = 65536;
      Name = "nofile";
      Soft = 65536;
    };
  };
}
