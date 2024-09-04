export PATH="$HOME/.local/bin:$PATH"
export EDITOR="vim"

[ "$(tty)" = "/dev/tty1" ] && exec \
	"$HOME/.config/river/launch"
