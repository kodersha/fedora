#!/usr/bin/env bash
set -euo pipefail

#----------------------------#
# Set Nvidia toolkit policy) #
#----------------------------#
semodule --verbose --install /usr/share/selinux/packages/nvidia-container.pp

#---------------------------------------------------------------------------------------#

#-------------------#
# Set early loading #
#-------------------#
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf
sed -i 's@ nvidia @ i915 amdgpu nvidia @g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf

#---------------------------------------------------------------------------------------#

#---------------#
# DRM Variables #
#---------------#
echo '

# Nvidia modesetting support. Set to 0 or comment to disable kernel modesetting
# support. This must be disabled in case of SLI Mosaic.

options nvidia-drm modeset=1 fbdev=1

' > /usr/lib/modprobe.d/nvidia-modeset.conf

cp /usr/lib/modprobe.d/nvidia-modeset.conf /etc/modprobe.d/nvidia-modeset.conf
