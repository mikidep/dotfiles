{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cosmic-applibrary
    cosmic-applets
    cosmic-bg
    cosmic-comp
    cosmic-edit
    cosmic-files
    cosmic-greeter
    cosmic-icons
    cosmic-launcher
    cosmic-notifications
    cosmic-osd
    cosmic-panel
    cosmic-randr
    cosmic-screenshot
    cosmic-settings
    cosmic-settings-daemon
    cosmic-term
    cosmic-workspaces-epoch
  ];
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-cosmic
    #xdg-desktop-portal-gtk
  ];
  systemd.packages = with pkgs; [cosmic-session];
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.sessionPackages = with pkgs; [cosmic-session];
  };
}
