#        .__
# _____  |  |     BOURNE AGAIN SHELL SETUP
# \__  \ |  |     Abdul Hakim (alarwasyi98)
#  / __ \|  |__   https://github.com/alarwasyi98/dotfiles
# (____  /____/   Version: 2.23.3
#      \/

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# BASH COMPLETION
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# ENVIRONMENT VARIABLES
export TERM="xterm-256color"
export EDITOR="nvim"
export VISUAL="nvim"
export BAT_THEME="gruvbox-dark"

# XDG Base Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# PATH
[ -d "$HOME/.bin" ] && PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.opencode/bin" ] && PATH="$HOME/.opencode/bin:$PATH"

# HISTORY
HISTCONTROL=ignoreboth # ignore duplicate and command started with (space)
HISTSIZE=10000
HISTFILESIZE=20000
HISTFILE="$HOME/.cache/bash/.bash_history"
HISTIGNORE="ls:cd:pwd:exit:sudo reboot:history:cd -:cd .."

# SHOPT

shopt -s autocd     # type dir name for cd directly
shopt -s cdspell    # Autocorrect typo when cd
shopt -s cmdhist    # Save multi-lline command as a single command in history
shopt -s dotglob    # Glob pattern also match hidden files (.)
shopt -s histappend # Append to history, not override
shopt -s expand_aliases
shopt -s checkwinsize # Updates terminal size after each command

# TOOL INITIALIZATION

## NVM — lazy load so it doesn't slow down
## Load is deferred until node/npm/nvm is called for the first time
export NVM_DIR="$HOME/.config/nvm"

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() {
  nvm
  node "$@"
}
npm() {
  nvm
  npm "$@"
}
npx() {
  nvm
  npx "$@"
}

# Zoxide (smarter cd)
eval "$(zoxide init bash)"

# Starship — prompt decoration
eval "$(starship init bash)"

# MANPAGER

export MANPAGER="nvim +Man!"

# FUNCTIONS

## Go up N directory level: `up 3`: `up 3`
up() {
  local d=""
  local limit="${1:-1}"
  [ "$limit" -le 0 ] && limit=1
  for ((i = 1; i <= limit; i++)); do d="../$d"; done
  cd "$d" || echo "Couldn't go up $limit dirs."
}

## extract various archives files: `extract file.tar.gz`
extract() {
  if [ -z "$1" ]; then
    echo "Usage: extract <file>"
    return 1
  fi
  for n in "$@"; do
    if [ -f "$n" ]; then
      case "${n%,}" in
      *.tar.bz2 | *.tbz2) tar xvjf "$n" ;;
      *.tar.gz | *.tgz) tar xvzf "$n" ;;
      *.tar.xz | *.txz) tar xvJf "$n" ;;
      *.tar) tar xvf "$n" ;;
      *.bz2) bunzip2 "$n" ;;
      *.gz) gunzip "$n" ;;
      *.rar) unrar x "$n" ;;
      *.zip | *.epub | *.cbz) unzip "$n" ;;
      *.7z) 7z x "$n" ;;
      *.xz) unxz "$n" ;;
      *.z) uncompress "$n" ;;
      *)
        echo "extract: '$n' - format unknown"
        return 1
        ;;
      esac
    else
      echo "'$n' - file not found"
      return 1
    fi
  done
}

## Yazi file manager with directory tracking
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

## Locate text in all files on current dir: `ftext "$args"`
ftext() {
  grep -iIHrn --color=always "$1" . | less -r
}

## Copy file dengan progress bar
cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
      count += $NF
      if (count % 10 == 0) {
        percent = count / total_size * 100
        printf "%3d%% [", percent
        for (i=0;i<=percent;i++) printf "="
        printf ">"
        for (i=percent;i<100;i++) printf " "
        printf "]\r"
      }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

## Copy and cd to destination dir
cpg() {
  if [ -d "$2" ]; then
    cp "$1" "$2" && cd "$2"
  else
    cp "$1" "$2"
  fi
}

## Move and cd to destination dir
mvg() {
  if [ -d "$2" ]; then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

## Make dir and cd inside
mkdirg() {
  mkdir -p "$1" && cd "$1"
}

## Distro Detective
distribution() {
  local dtype="unknown"
  if [ -r /etc/os-release ]; then
    . /etc/os-release
    case $ID in
    fedora | rhel | centos) dtype="redhat" ;;
    sles | opensuse*) dtype="suse" ;;
    ubuntu | debian) dtype="debian" ;;
    gentoo) dtype="gentoo" ;;
    arch) dtype="arch" ;;
    slackware) dtype="slackware" ;;
    esac
  fi
  echo "$dtype"
}

## OS Detection
ver() {
  local dtype
  dtype=$(distribution)
  case $dtype in
  "redhat")
    [ -s /etc/redhat-release ] && cat /etc/redhat-release || cat /etc/issue
    uname -a
    ;;
  "suse") cat /etc/SuSE-release ;;
  "debian") lsb_release -a ;;
  "gentoo") cat /etc/gentoo-release ;;
  "arch") cat /etc/os-release ;;
  "slackware") cat /etc/slackware-version ;;
  *) [ -s /etc/issue ] && cat /etc/issue || echo "Error: Unknown distribution" ;;
  esac
}

## Install supporting programs
install_support() {
  local dtype
  dtype=$(distribution)
  case $dtype in
  "redhat") sudo yum install eza zoxide trash-cli fzf bash-completion neofetch ;;
  "suse") sudo zypper install eza zoxide trash-cli fzf bash-completion neofetch ;;
  "debian")
    sudo apt-get install eza zoxide trash-cli fzf bash-completion neofetch
    curl -sS https://starship.rs/install.sh | sh
    ;;
  "arch") yay -S eza zoxide trash-cli fzf bash-completion neofetch starship colorscript-git ;;
  *) echo "Distribusi tidak dikenali" ;;
  esac
}

## Check internal and eksternal IP
whatsmyip() {
  echo -n "Internal IP: "
  if command -v ip &>/dev/null; then
    ip addr show | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | head -1
  else
    echo "N/A"
  fi
  echo -n "External IP: "
  curl -s ifconfig.me
  echo
}
alias whatismyip="whatsmyip"

## Git: add all + commit
gcom() {
  git add .
  git commit -m "$1"
}

## Git: add all + commit + push
lazyg() {
  git add .
  git commit -m "$1"
  git push
}

# ALIASES

## Editor
alias vim="nvim"
alias vi="nvim"
alias svi="sudo nvim"
alias vis='nvim "+set si"'
alias cls="clear"

## Config shortcuts
alias ebrc='nvim ~/.bashrc'
alias reloadbash="source ~/.bashrc && echo 'Bash reloaded successfully!'"
alias showconf='bat ~/.bashrc'
alias staredit='nvim $HOME/.config/starship.toml'

## eza as replacement for ls
alias ls='eza -xAah --git --color=always --icons=always --no-user --no-permissions --no-filesize --no-time'
alias lw='eza -xAh --icons=always'
alias ll='eza -l -a --icons=always --color=always --git'
alias lt='eza --tree --icons=always --color=always'
alias l.='eza -al --color=always --group-directories-first ../'
alias l..='eza -al --color=always --group-directories-first ../../'
alias l...='eza -al --color=always --group-directories-first ../../../'

## Directory Navigation
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias bd='cd "$OLDPWD"'

## General Util(s)
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias less='less -R'
alias df='df -h'
alias free='free -m'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias da='date "+%Y-%m-%d %A %T %Z"'
alias sha1='openssl sha1'

## chmod shortcuts
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

## Process Operation
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

## Searching
alias h="history | grep"
alias p="ps aux | grep"
alias f="find . | grep"
alias countfiles="for t in files links directories; do echo \$(find . -type \${t:0:1} | wc -l) \$t; done 2>/dev/null"
alias checkcommand="type -t"

## Disk
alias diskspace="du -S | sort -n -r | more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias mountedinfo='df -hT'
alias openports='netstat -nape --inet'

## Tar shortcuts
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

## fzf
alias cdf='cd $(fd -t d | fzf)'
alias fvim='nvim $(fzf --preview="bat --color=always {}" --bind shift-up:preview-page-up,shift-down:preview-page-down)'
alias ff='fzf --preview=less --bind shift-up:preview-page-up,shift-down:preview-page-down'

## Logs
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e 's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

## Git shorthand
alias gla='git log --oneline --graph --all'
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias stat='git status'
alias tag='git tag'
alias newtag='git tag -a'

## Arch Linux - Pacman & Paru
alias pacsyu='sudo pacman -Syu'
alias pacsyyu='sudo pacman -Syyu'
alias parsua='paru -Sua --noconfirm'
alias parsyu='paru -Syu --noconfirm'
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias orphan='sudo pacman -Rns $(pacman -Qtdq)'

## Arch Linux - Relflector Mirror
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

## GPG
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

## Clipboard (WSL: use clip.exe / powershell.exe as fallback)
if command -v xsel &>/dev/null; then
  alias pbcopy="xsel --input --clipboard"
  alias pbpaste="xsel --output --clipboard"
else
  alias pbcopy="clip.exe"
  alias pbpaste="powershell.exe -command 'Get-Clipboard'"
fi

## Reboot
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

## Change default login shell
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Log out and log back in to take effect'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Log out and log back in to take effect'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Log out and log back in to take effect'"

## Termbin
alias tb="nc termbin.com 9999"

# STARTUP DISPLAY

colorscript --exec blocks1
