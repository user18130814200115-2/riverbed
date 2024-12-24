# Riverbed

Riverbed is a set of configuration files and programs to turn the [river
wayland compositor](https://codeberg.org/river/) into a bare-bones desktop
environment.

## Installation

See [INSTALL.md](INSTALL.md) for instructions on Alpine and NixOs.

## Usage

Riverbed is configured through the use of a few configuration files as well as
the `riverbedctl` command. The configuration files are located at `config/river`
and are named `variables`, `keybinds, `autostart`, and `custom`. The purpose of
each should be clear by the name. Important to note is that`keybinds` and
`custom` are both scripts allowing for greater flexibility.

### Variables

The following variables can be set, below are their default values:

```
gaps=5
padding=10
main_ratio=0.60
bar_height=48
border_size=2

background_color=808080
window_color=ffffff
border_color=000000
border_color_inactive=808080
text_color=000000
font="DroidSansM Nerd Font"
monofont="DroidSansM Nerd Font Mono"

cursor_theme='capitaine-cursors-dark'
background=""

layout=runoff
columns=3
dynamic_columns=true
```

### Riverbedctl

`riverbedctl` is the command line utility used for updating aspects of the
desktop such as the current layout, gaps, border-colors, etcetera. Unlike
`riverctl`, riverbedctl will inform the various parts of the desktop
synchronously. Therefore, changing the layout will for instance change the size
and position of the system bar.

These are the various functions of riverbedctl:

- Setting any variable from `config/river/variables` by calling `riverbedctl
  variable=value`. These settings must be saved manually to the configuration
  file and will otherwise me lost upon reset.
- Calling any function from `config/river/init` notably
	+ `customs` will reload the `config/river/customs` file
	+ `reload_keybinds` will reload the `config/river/keybinds` file
- riverbedctl will always re-synchronize the configurations for wob, waybar,
  fnott, tofi, and luatile


## Programs

Riverbed uses the following programs:

| program | Purpose |
|----------------|--------------------------|
| river | Compositor |
| river-luatile | Layout Manager |
| waybar | Status bar |
| tofi | Launcher, Polkit-agent * pinentry |
| fnott | Notifications |
| wob | Volume and Brightness OSD |

Riverbed does rely on other programs and libraries to be present on your system,
please check `etc/apk/world` for a full list. 

I personally use the KDE suite of applications, but this can easily be
substituted by with GNOME or DE agnostic applications.

## Window layout

Riverbed supports three different window layouts, each with various settings.

`Runoff` is a simple master-stack layout which always reserves space for the
stack, even if there is only one window in screen. It also reserves space for
the bar which only takes up around 40% of the screen width.  The size of the
master and stack can be controlled with the `main_ratio` variable.

`Dual` is a variation on the mater stack layout which will make the main window
take up the center and align one stack on either side.

`Grid` will sort windows into a more-or-less equal grid of windows. This layout
ignores the `main_ratio` window and does is the only one where the bar takes up
the full screen width. The grid is controlled by two variables: `columns` is a
hard-coded limit to the number to horizontal stacks riverbed will sort windows
into. While `dynamic_columns` can be set to dynamically create more columns as
the number of windows increase.

## Screenshots

### Runoff
![runoff](pictures/runoff.png)

### Dual
![dual](pictures/dual.png)

### Grid
![grid](pictures/grid.png)

### Launcher, OSD and Notification use the same space and styling as the bar
![launcher](pictures/launcher.png)
![osd](pictures/osd.png)
![notification](pictures/notification.png)

