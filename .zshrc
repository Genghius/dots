status_nums(){
        [ $? -ne 0 ] && printf " %s " "%F{red}%?%f"
        [ $(jobs -l | wc -l) -ne 0 ] && printf " %s " "%F{green}%j%f"
}

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
setopt prompt_subst
#PS1='%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~$(status_nums)%{$fg[red]%}]%{$reset_color%}$%b '
PS1='%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~$(status_nums)%{$fg[red]%}]%{$reset_color%}$%b '
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if existent.
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

#CANCER STARTS HERE
export PATH=~/.local/bin:.:$PATH
export EDITOR=vim
export SHFM_OPENER=/home/dan/.local/bin/SHFM_OPENER
export FFF_COL1=4
export FFF_COL2=7
export FFF_OPENER="xdg-open"
export FFF_MARK_FORMAT="> %f"
export TESSDATA_PREFIX=~/.local/tessdata

# Memes
alias :q='echo "E37: No write since last change (:q! overrides)"'
alias :q!='exit'

alias gibberish="curl -s https://soybomb.com/tricks/words/ | pup 'table text{}' | sed -n '/^[^$]/p' | sed -n '6,\$p'"
alias waifufetch='neofetch --chafa ~/Pictures/screenshots/HALF-UNHOLY/$(\ls ~/Pictures/screenshots/HALF-UNHOLY | sort -R | sed 1q)'
alias weather='curl wttr.in'
alias dvtm='dvtm -m ^z'
alias surf='tabbed -c surf -e'
alias mkdir='mkdir -vp'
alias cp='cp -v'
alias bc='bc -ql'
alias grep='grep --color'
alias zte='ssh 192.168.0.8 -p 8022'
alias maze='ssh 192.168.0.5 -p 8022'
alias keyboard='setxkbmap '
alias SN='poweroff'
alias SRN='reboot'
alias LO='i3-msg exit'
alias ls='ls --color'
alias mediahelp='echo "imageconv [format1] [format2]\t-Converts all images of format1 to format2 in current directory. Example: imageconv jpg png\nvideocut [start] [file] ([out] || [stop] [out])\t-Cuts video file from start seconds until end, or stop seconds after start, outputs to out. Example: videocut 10 video.mkv 5 out.mkv\nyoutube-dl-playlist [link]\nvis\t-Visualize audio\ncsv [separator] [file]\ngibberish\nwaifufetch\nweather\nanonupload [filename]\nrecord [OPTIONAL FRAMERATE]"'
alias vi='nvim'
alias sudo='doas -u root --'
alias youtube-dl-playlist='youtube-dl -i -f mp4 --yes-playlist'
alias getperson="wget https://thispersondoesnotexist.com/image"
alias gccasm="gcc -S -masm=intel -fverbose-asm"
alias disasm="objdump -d"
alias dump="objdump -x"
alias stripblt="strip -R .note -R .comment -R .eh_frame -R .eh_frame_hdr"
alias clock="while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done &"

# Extracts files in archives
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.tar.xz)    tar -xf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#hide window until process returns
swallow() (
    [ ! -z "$1" ] || exit 1
    WINID="$(xdotool getactivewindow)" || exit 1

    "$@" 2> /dev/null &
    xdotool windowunmap "$WINID" && wait
    xdotool windowmap "$WINID"
)

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

# Cheatsheets
cheatsheet() {
	curl "cht.sh/$1"
}

imageconv() {
	\ls *.$1 | time parallel -j+0 convert {} {/.}".$2"
}

videocut(){
	ffmpeg -ss "$1" -i "$2" -c copy $( [ "$4" ] && echo "-t $3 $4" || echo "$3")
}

f(){
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

csv(){
        column -s"$1" -t < "$2" | less -#2 -N -S
}

coords(){
        curl "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$1&longitude=$2&localityLanguage=en"
}

anonupload(){
        curl -F "file=@$1" https://api.anonfiles.com/upload
}

assemble(){
        while [ "$1" ]; do
                nasm -f elf64 $1
                ld ${1/.*}.o -o ${1/.*}
                rm ${1/.*}.o
                shift
        done
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
bindkey '^w' forward-word
bindkey '^[w' backward-word
bindkey -s '^a' shfm^M
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
