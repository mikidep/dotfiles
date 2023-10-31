{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces";
  version = "v1.2.5";

  src = fetchFromGitHub {
    owner = "FieldofClay";
    repo = pname;
    rev = version;
    hash = "sha256-5/add1VSJe5ChKi4UU5iUKRAj4kMjOnbB76QX/FkA6k=";
  };

  cargoHash = "sha256-I7MFrDki0yV4MKFUSNiAK80N1ZLWQD6XxKWZTCyqIg8=";

  meta = with lib; {
    description = "A multi-monitor aware Hyprland workspace widget";
    homepage = "https://github.com/FieldofClay/hyprland-workspaces";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };
}