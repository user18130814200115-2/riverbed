export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
export XDG_RUNTIME_DIR=$(mkrundir)

[ "$(tty)" = "/dev/tty1" ] && exec \
	ck-launch-session dbus-launch --sh-syntax --exit-with-session seatd-launch -- river

