cleanup:
  #!/usr/bin/bash

  podman image prune -af
  podman volume prune -f
  flatpak uninstall --unused
  rpm-ostree cleanup -bm
  brew cleanup
