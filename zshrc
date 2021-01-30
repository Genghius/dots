
# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.

# History in cache directory:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if existent.
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

#CANCER STARTS HERE
export PATH=~/.local/bin:.:$PATH
export EDITOR=vim
export SHFM_OPENER=~/.local/bin/SHFM_OPENER
export FFF_COL1=4
export FFF_COL2=7
export FFF_OPENER="xdg-open"
export FFF_MARK_FORMAT="> %f"

alias dvtm='dvtm -m ^z'
alias surf='tabbed -c surf -e'
alias mkdir='mkdir -vp'
alias cp='cp -v'
alias grep='grep --color'
alias keyboard='setxkbmap '
alias ls='ls --color'

# Extracts files in archives
extract () {
	for file in $@ ; do
	    if [ -f $file ] ; then
	        case $file in
	            *.tar.bz2)   tar xjf $file     ;;
	            *.tar.gz)    tar xzf $file     ;;
	            *.tar.xz)    tar -xf $file     ;;
	            *.bz2)       bunzip2 $file     ;;
	            *.rar)       unrar e $file     ;;
	            *.gz)        gunzip $file      ;;
	            *.tar)       tar xf $file      ;;
	            *.tbz2)      tar xjf $file     ;;
	            *.tgz)       tar xzf $file     ;;
	            *.zip)       unzip $file       ;;
	            *.Z)         uncompress $file  ;;
	            *.7z)        7z x $file        ;;
	            *)     echo "'$file' cannot be extracted via extract()" ;;
	        esac
	    else
	        echo "'$file' is not a valid file"
	    fi
	done
}

# Compresses files
compress() {
    FILE=$1
    shift
    case $FILE in
        *.tar.bz2) tar cjf $FILE $*  ;;
        *.tar.gz)  tar czf $FILE $*  ;;
        *.tgz)     tar czf $FILE $*  ;;
        *.zip)     zip $FILE $*      ;;
        *)         echo "Filetype not recognized" ;;
   esac
}

#CANCER ENDS HERE

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

#bindings
bindkey '^g' beginning-of-line
bindkey '^[g' end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^w' forward-word
bindkey '^[w' backward-word
bindkey -s '^[m' 'dvtm -m \^z'^M
# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load syntax highlighting; should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

if [ -e /home/dan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
