#!/bin/sh -eux

# Only add the secure path line if it is not already present
grep -q 'secure_path' /etc/sudoers \
  || sed -i -e '/Defaults\s\+env_reset/a Defaults\tsecure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' /etc/sudoers;

# Set up password-less sudo for the pi user
echo 'pi ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_pi;
chmod 440 /etc/sudoers.d/99_pi;
