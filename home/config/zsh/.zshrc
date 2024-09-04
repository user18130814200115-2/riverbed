zstyle :compinstall filename '/home/user/.config/zsh/.zshrc'

autoload -Uz compinit
compinit

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

PROMPT="%B%1~ %#%b "
