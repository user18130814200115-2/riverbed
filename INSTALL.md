# Installation Instructions

## Preface
These instructions are only valid for alpine Linux, other Linux distributions
are currently unsupported.

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

Riverbed needs a variety of programs to work properly. These are listed in
`etc/apk/world` and `custom_packages`.

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
```
