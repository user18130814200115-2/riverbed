# Riverbed

Riverbed is a set of configuration scripts and programs to turn the [river wayland compositor](https://codeberg.org/river/) into a bare-bones desktop environment.

## Installation

This repository is designed for installation on top of an existing alpine console installation

The files in the config folder go into `$XDG_CONFIG_HOME`.

Files in the etc folder must be moved by a privileged user into `/etc/`.

### !!! WARNING !!!
You Should **ADD** the contents of etc/apk/world to your existing apk world file,
**DO NOT REPLACE THE FILE OR YOU MAY BREAK YOUR INSTALL**.
The file in this repository does not contain a Linux kernel, network divers, etcetera.

## Programs

Riverbed uses the following programs
| program | Purpose |
|----------------|--------------------------|
| river | Compositor |
| river-luatile | Layout Manager |
| way bar | Status bar |
| tofi | Launcher |
| mako | Notifications |
| brightness | Brightness management |
| lxqt-policykit | GUI Privilege escalation |
| grim shot | Screenshots |
| doas | CLI privilege escalation |

I personally use the KDE suite of applications, but this can easily be substituted by wither GNOME or diagnostic applications.

## Screenshots

`Coming Soon`

## Hacks

The current way bar config is a bit of a hack, using a transparent bar with a wide left-side margin to get a partial bar.
I am working on a patch for way bar that allows one to set a smaller bar anchored to a corner to alleviate this problem.
