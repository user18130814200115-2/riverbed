export PATH="$PATH:$HOME/.local/bin"
export EDITOR="vim"

[ "$(tty)" = "/dev/tty1" ] && exec \
	"$HOME/.config/river/launch"
