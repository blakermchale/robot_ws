#!/bin/bash

chown ${USERNAME}:${USERNAME} /home/${USERNAME}
echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME}
chmod 0440 /etc/sudoers.d/${USERNAME}
adduser ${USERNAME} root  >/dev/null
adduser ${USERNAME} video >/dev/null
adduser ${USERNAME} plugdev >/dev/null
adduser ${USERNAME} sudo  >/dev/null
adduser ${USERNAME} kvm  >/dev/null  # WSL specific

groupmod -g 138 sgx

if [ -c /dev/dri/renderD128 ]; then
  RENDER_GID="$(stat -c %g /dev/dri/renderD128)"
  addgroup --gid ${RENDER_GID} render >/dev/null
  groupmod -g ${RENDER_GID} render >/dev/null
  adduser ${USERNAME} render >/dev/null
fi

# Restart udev daemon
service udev restart

exec gosu ${USERNAME} "$@"
