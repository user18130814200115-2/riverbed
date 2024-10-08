#!/bin/sh

warn() {
	printf '\x1b[1;31m[WARNING]:\x1b[0m %s\n' "$@"
}

inform() {
	printf '\x1b[32m[INFO]:\x1b[0m %s\n' "$@"
}

install_configs() {
	inform "Installing user configurations"
	if [ -z $XDG_CONFIG_HOME ]; then
		config_dir="$HOME/.config/"
		inform "XDG_CONFIG_HOME evnironemnt varible is unset, defaulting to $config_dir"
	else
		config_dir="$XDG_CONFIG_HOME"
	fi

	inform "Installing configuration for river"
	source_dir="./home/config/river"
	install -D -b -t "$config_dir" $source_dir/autostart $source_dir/custom $source_dir/variables
	install -D -b -t "$config_dir/river" -m 744 $source_dir/init $source_dir/keybinds $source_dir/launch
	source_dir="./home/config/river-luatile"
	install -D -b -t "$config_dir/river-luatile" $source_dir/*

	inform "Installing configuration for waybar"
	source_dir="./home/config/waybar"
	install -D -b -t "$config_dir/waybar" $source_dir/*

	inform "Installing configuration for fnott"
	source_dir="./home/config/fnott"
	install -D -b -t "$config_dir/fnott" $source_dir/*

	inform "Installing configuration for wob"
	source_dir="./home/config/wob"
	install -D -b -t "$config_dir/wob" $source_dir/*

	inform "Installing configuration for gtklock"
	source_dir="./home/config/gtklock"
	install -D -b -t "$config_dir/gtklock" $source_dir/*

	inform "Installing configuration for tofi"
	source_dir="./home/config/tofi"
	install -D -b -t "$config_dir/tofi" $source_dir/*

	inform "Installing configuration for xdg-desktop-portal"
	source_dir="./home/config/xdg-desktop-portal"
	install -D -b -t "$config_dir/xdg-desktop-portal" $source_dir/*
	source_dir="./home/config/xdg-desktop-portal-wlr"
	install -D -b -t "$config_dir/xdg-desktop-portal-wlr" $source_dir/*

	inform "Installing configuration for yash"
	source_dir="./home"
	install -D -b -t "$HOME/.yashrc" $source_dir/yashrc

	inform "Installing configuration for libinput-gestures"
	source_dir="./home/config"
	install -D -b -t "$config_dir" $source_dir/libinput-gestures.conf

	inform "Installing configuration for gnupg"
	install -D -b -t "$HOME/.gnupg" "./home/gnupg/gpg-agent.conf"
	install -D -b -t "$HOME/.gnupg" -m 744 "./home/gnupg/pinentry-tofi"

	inform "Installing custom scripts"
	install -D -b -t "$HOME/.local/bin" -m 744 home/local/bin/*

	#inform "Installing shell profile"
	#install -b "home/profile" "$HOME/.profile"

}

install_packages() {
	if [ $(which apk) ]; then
		inform "Attempting to install packages using apk"
		if [ "$(grep "^[^#].*/testing" /etc/apk/repositories)" ]; then
			inform "Testing repository enabled"
		else
			inform "Enabling testing repository"
			$root sh -c "echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories"
		fi

		xargs $root apk add < etc/apk/world && compile_packages

	else
		warn "Apk tools not found on system. You are on your own when it comes to installing the necessary programs"
		inform "Programs required by the default installation are:"
		echo $(cat etc/apk/world; ls custom-packages)
	fi
}

compile_packages() {
	inform "Attempting to compile custom packages"
	riverbed_directory=$(pwd)
	cd custom-packages
	ls | while read line; do
			inform "Compiling $line"
			cd $line
			abuild -rP "$riverbed_directory"
			cd ..
	done

	ls | while read line; do
		if [ "$line" == "aarch64" ] || [ "$line" == "x86" ] || [ "$line" == "x86_64" ] || [ "$line" == "armv7" ]; then
			ls $line/*.apk | xargs $root apk add --allow-untrusted 
		fi
	done
}

warn "This script is not production ready, press ENTER to continue"
read

if [ $(which doas) ]; then
	inform "Found doas for privilege escalation"
	root=doas
elif [ $(which sudo) ]; then
	inform "Found sudo for privilege escalation"
	root=sudo
else
	inform "Did not find doas nor sudo, defaulting to su for privilege escalation"
	root="su root -c"
fi

if [ $(which abuild) ]; then
	inform "Abuild present"
else
	inform "Installing abuild"
	$root apk add abuild
fi

if [ "$(groups | grep abuild)" ]; then
	inform "$USER is in group abuild"
else
	warn "User is not in the abuild group. Adding now"
	$root adduser $USER abuild
	warn "Please re-log for the changes to take effect"
fi

inform "All checks passed, start installation?"
read

install_configs
install_packages

if [ "$(groups | grep seat)" ]; then
	inform "$USER is in group seat"
else
	warn "User is not in the seat group. Adding now"
	$root adduser $USER seat
	warn "Please re-log for the changes to take effect"
fi

warn "Autostart is not enabled for security reasons. Check first if config/river/launch works, then run install -b \"home/profile\" \"$HOME/.profile\""
inform "Install finished"
