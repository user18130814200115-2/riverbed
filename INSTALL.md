# Installation Instructions

## Preface

There are two supported distributions for installation, those being Alpine Linux
and NixOs. Currently, I am using NixOs and it is therefore the best supported.
There are some substantive differences between these two installations,
primarily since the Nix install uses systemd, while the Alpine install does
not. The `config/river/launch` script should account for this, though it is
untested on Alpine at the moment.


# Nixos

The easiest install is on NixOs. Simply clone this repository into `/etc/nixos/`
and import `./riverbed/riverbed.nix` from your configuration. 

## Manual intervention

Currently manual intervention is required for getting the window switcher to
work. This involves installing `pywayland' possibly through pip, and installing
the river wayland protocols.

The process is more or less like this: (the process below uses `pip`, `wget`,
and `gcc`, but the process should be the same with `uv`, `curl`, etc.)

```
pip install pywayland

wget https://raw.githubusercontent.com/riverwm/river/refs/heads/master/protocol/river-control-unstable-v1.xml
wget https://raw.githubusercontent.com/riverwm/river/refs/heads/master/protocol/river-status-unstable-v1.xml

python3 -m pywayland.scanner -i /usr/share/wayland/wayland.xml river-control-unstable-v1.xml river-status-unstable-v1.xml
apk del pip gcc wget
rm river-control-unstable-v1.xml river-status-unstable-v1.xml
```

You might get an error from pip about python being externall managed. This can
be worked around by removing /usr/lib/python3.12/EXTERNALLY-MANAGED.

Once I find a more elegant way of installing these elements, the installation
will be added to the nix module

# Alpine

## Automatic install [EXPERIMENTAL]

The install script `install.sh` is currently in a very early alpha version. Use
it at your own digression.  Positively though, it shouldn't be able to mess up
your system too bad.

To use the install script on a fresh alpine install run
```
git clone https://github.com/user18130814200115-2/riverbed
cd riverbed
chmod +x ./install.sh
./install.sh

```

## Manual install

### Installing packages

Most programs used in this setup are available in the main alpine repositories,
though some are currently in testing. Other still are not available at all, this
repository contains custom `APKBUILD` files for these programs. The packages
used are listed in `etc/apk/world` and `custom_packages`.

The alpine packages can be installed by running this command from the root of
this repository.
```
xargs apk add < etc/apk/world 
```
Make sure the [testing repository is enabled on your
system](https://wiki.alpinelinux.org/wiki/Repositories#Using_testing_repository).

The custom packages must each be compiled and then added. For each package,
complete the following steps:
```
cd custom_packages/[PACKAGENAME]
abuild -rP "[RIVERBED DIRECTORY]"
cd ../[ARCHITECTURE]
apk add [PACKAGENAME]*
```
Replace [PACKAGENAME] [RIVERBED DIRECTORY] and [ARCHITECTURE] with the
appropriate values.

### Installing configuration files

All files in the `home` directory must be moved into your `$HOME` directory and
prepended with a period.

- `home/config/` -> `$HOME/.config/`
- `home/profile` -> `$HOME/.profile`
- `home/gnupg/` -> `$HOME/.gnupg`

Etcetera

Certain files also need execute permissions. To set these, run
```
chmod +x ~/.config/river/init ~/.config/river/keybinds ~/.config/river/launch ~/.gnupg/pinentry-tofi ~/.local/bin/*

### Manual

Currently manual intervention is required for getting the window switcher to
work. This involves installing `pywayland' possibly through pip, and installing
the river wayland protocols.

The process is more or less like this: (the process below uses `pip`, `wget`,
and `gcc`, but the process should be the same with `uv`, `curl`, etc.)

```
apk add pip gcc wget
pip install pywayland

wget https://raw.githubusercontent.com/riverwm/river/refs/heads/master/protocol/river-control-unstable-v1.xml
wget https://raw.githubusercontent.com/riverwm/river/refs/heads/master/protocol/river-status-unstable-v1.xml

python3 -m pywayland.scanner -i /usr/share/wayland/wayland.xml river-control-unstable-v1.xml river-status-unstable-v1.xml
apk del pip gcc wget
rm river-control-unstable-v1.xml river-status-unstable-v1.xml
'''

You might get an error from pip about python being externall managed. This can
be worked around by removing /usr/lib/python3.12/EXTERNALLY-MANAGED.

Once I find a more elegant way of installing this I will add it to the install
script.
```
