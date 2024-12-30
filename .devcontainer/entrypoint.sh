#!/bin/bash

# echo "Creating non-root container '${USERNAME}' for host user uid=${HOST_USER_UID}:gid=${HOST_USER_GID}"

# if [ ! $(getent group ${HOST_USER_GID}) ]; then
#   groupadd --gid ${HOST_USER_GID} ${USERNAME} &>/dev/null
# else
#   CONFLICTING_GROUP_NAME=`getent group ${HOST_USER_GID} | cut -d: -f1`
#   groupmod -o --gid ${HOST_USER_GID} -n ${USERNAME} ${CONFLICTING_GROUP_NAME}
# fi

# if [ ! $(getent passwd ${HOST_USER_UID}) ]; then
#   useradd --no-log-init --uid ${HOST_USER_UID} --gid ${HOST_USER_GID} -m ${USERNAME} &>/dev/null
# else
#   CONFLICTING_USER_NAME=`getent passwd ${HOST_USER_UID} | cut -d: -f1`
#   usermod -l ${USERNAME} -u ${HOST_USER_UID} -m -d /home/${USERNAME} ${CONFLICTING_USER_NAME} &>/dev/null
#   mkdir -p /home/${USERNAME}
#   # Wipe files that may create issues for users with large uid numbers.
#   rm -f /var/log/lastlog /var/log/faillog
# fi

# chown ${USERNAME}:${USERNAME} /home/${USERNAME}
# echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME}
# chmod 0440 /etc/sudoers.d/${USERNAME}
adduser ${USERNAME} video >/dev/null
adduser ${USERNAME} plugdev >/dev/null
adduser ${USERNAME} sudo  >/dev/null

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
