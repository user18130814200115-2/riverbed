# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
	imports =
		[
				<home-manager/nixos>
		];

	services.pipewire = {
		enable = true;
		pulse.enable = true;
	};

	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = false;

	services.libinput.enable = true;

	home-manager.backupFileExtension = "bak";

	home-manager.users.user = {
		home.stateVersion = "24.11";
		
		gtk.cursorTheme.package = pkgs.capitaine-cursors;
		home.file = {
				".yashrc".source = ./home/yashrc;
				".config" = {
						source = ./home/config;
						recursive = true;
				};
				".vim" = {
						source = ./home/vim;
				};
				".vimrc" = {
						source = ./home/vimrc;
				};
				".gnupg" = {
						source = ./home/gnupg;
						recursive = true;
				};
				".gnupg/pinentry-tofi" = {
								source = ./home/gnupg/pinentry-tofi;
								executable = true;
						};
				".local/bin" = {
						source = ./home/local/bin;
						recursive = true;
						executable = true;
				};
		};
	};

	security.pam.services.gtklock = {};

	xdg.portal.extraPortals = with pkgs; [ lxqt.xdg-desktop-portal-lxqt ];
	xdg.portal.config = {
		common = {
			default = [
				"lxqt"
			];
		};
	};

	environment.variables = {
	#	"XDG_CURRENT_DESKTOP" = "lxqt";
 
		"QT_QPA_PLATFORM" = "wayland";
		"QT_QPA_PLATFORMTHEME" = "xdgdesktopportal";
		"QT_STYLE_OVERRIDE" = "kvantum";
	};

	fonts.packages = with pkgs; [
		unstable.nerd-fonts.droid-sans-mono
		noto-fonts
	];

	environment.systemPackages = with pkgs; [
		jq
		bc
		adwaita-icon-theme
		brightnessctl
		fnott
		foot
		pulsemixer
		river
		river-luatile
		tofi
		waybar
		wbg
		wlr-randr
		wob
		xdg-desktop-portal
		#lxqt.xdg-desktop-portal-lxqt
		sway-contrib.grimshot
		pass
		passExtensions.pass-otp
		gtklock
		cmd-polkit
		libinput-gestures
		kdePackages.qtstyleplugin-kvantum
	];
}

