#        .__
# _____  |  |     BOURNE AGAIN SHELL SETUP
# \__  \ |  |     Abdul Hakim (alarwasyi98)
#  / __ \|  |__   https://github.com/alarwasyi98
# (____  /____/
#      \/
#                 last modified: 2024-09-12

### OTHER SCRIPT ##
# Load other bash scripts if necessary
# [ -f ~/.bash_aliases ] && . ~/.bash_aliases
# [ -f ~/.bash_functions ] && . ~/.bash_functions
# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

### SETUP XDG DIR ###
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

### EXPORT ###
export EDITOR=nvim
export VISUAL=nvim
export BAT_THEME=Dracula
export TERM="xterm-256color" # getting proper colors
# Comented for performance issues
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

### HISTORY CONTROL ###
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

### SHOPT ###
shopt -s autocd  # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend     # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control

### HAVE NO IDEA ABOUT THESE ###
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Color for manpages in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

### DEFAULT EDITOR ###
alias pico='edit'
alias spico='sedit'
alias nano='edit'
alias snano='sedit'
alias vim='nvim'
alias edit='vim'

### ALIASES ###
# color support for grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# To temporarily bypass an alias, we precede the command with a \
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit this .bashrc file
alias ebrc='edit ~/.bashrc'
alias reloadbash="source ~/.bashrc && echo 'Bash reloaded successfully!'"
alias showconf='bat ~/.bashrc'

# Edit starship.toml
alias staredit='edit $HOME/.config/starship.toml'

# Show help for this .bashrc file
alias hlp='less $HOME/.bashrc_help'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias vi='nvim'
alias svi='sudo vi'
alias vis='nvim "+set si"'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's for multiple directory listing commands
# alias la='eza -Alh --color=always --icons=always --no-user --no-permissions' # show hidden files
alias ls='eza -xAah --git --color=always --icons=always --no-user --no-permissions --no-filesize --no-time' # add colors and file type extensions
alias lw='eza -xAh --icons=always'                                                                          # wide listing format
alias ll='eza -l -a --icons=always --color=always --git'                                                    # long listing format

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'

# alias tree='tree -CAhF --dirsfirst'
alias tree='eza --tree --icons=always --color=always'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# git
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
alias tag='git tag'
alias newtag='git tag -a'

# pacman and yay
alias pacsyu='sudo pacman -Syu'                # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'              # Refresh pkglist & update standard pkgs
alias parsua='paru -Sua --noconfirm'           # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'           # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck'  # remove pacman lock
alias orphan='sudo pacman -Rns (pacman -Qtdq)' # remove orphaned packages (DANGEROUS!)

# tar
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# fzf
alias cdf='cd $(fd -t d | fzf)'                                                                                         # fd-find and fzf needs to be preinstalled
alias fvim='nvim $(fzf --preview="bat --color=always {}" --bind shift-up:preview-page-up,shift-down:preview-page-down)' # nvim, bat and fzf needs to be preinstalled
alias ff='fzf --preview=less --bind shift-up:preview-page-up,shift-down:preview-page-down)'                             # fzf and less needs to be preinstalled

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

# change your default USER shell
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Log out and log back in for change to take effect.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Log out and log back in for change to take effect.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Log out and log back in for change to take effect.'"

# copy paste
alias pbcopy="xsel --input --clipboard"
alias pbpaste="xsel --output --clipboard"

#######################################################
# SPECIAL FUNCTIONS
#######################################################
# Extracts any archive(s) (if unp isn't installed)
extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case $archive in
      *.tar.bz2) tar xvjf $archive ;;
      *.tar.gz) tar xvzf $archive ;;
      *.bz2) bunzip2 $archive ;;
      *.rar) rar x $archive ;;
      *.gz) gunzip $archive ;;
      *.tar) tar xvf $archive ;;
      *.tbz2) tar xvjf $archive ;;
      *.tgz) tar xvzf $archive ;;
      *.zip) unzip $archive ;;
      *.Z) uncompress $archive ;;
      *.7z) 7z x $archive ;;
      *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

# Searches for text in all files in the current folder
ftext() {
  # -i case-insensitive
  # -I ignore binary files
  # -H causes filename to be printed
  # -r recursive search
  # -n causes line number to be printed
  # optional: -F treat search term as a literal, not a regular expression
  # optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
  grep -iIHrn --color=always "$1" . | less -r
}

# Copy file with a progress bar
cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Copy and go to the directory
cpg() {
  if [ -d "$2" ]; then
    cp "$1" "$2" && cd "$2"
  else
    cp "$1" "$2"
  fi
}

# Move and go to the directory
mvg() {
  if [ -d "$2" ]; then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

# Create and go to the directory
mkdirg() {
  mkdir -p "$1"
  cd "$1"
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
  local d=""
  limit=$1
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

# Automatically do an ls after each cd, z, or zoxide
cd() {
  if [ -n "$1" ]; then
    builtin cd "$@" && ls
  else
    builtin cd ~ && ls
  fi
}

# Returns the last 2 fields of the working directory
pwdtail() {
  pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Show the current distribution
distribution() {
  local dtype="unknown" # Default to unknown

  # Use /etc/os-release for modern distro identification
  if [ -r /etc/os-release ]; then
    source /etc/os-release
    case $ID in
    fedora | rhel | centos)
      dtype="redhat"
      ;;
    sles | opensuse*)
      dtype="suse"
      ;;
    ubuntu | debian)
      dtype="debian"
      ;;
    gentoo)
      dtype="gentoo"
      ;;
    arch)
      dtype="arch"
      ;;
    slackware)
      dtype="slackware"
      ;;
    *)
      # If ID is not recognized, keep dtype as unknown
      ;;
    esac
  fi

  echo $dtype
}

# Show the current version of the operating system
ver() {
  local dtype
  dtype=$(distribution)

  case $dtype in
  "redhat")
    if [ -s /etc/redhat-release ]; then
      cat /etc/redhat-release
    else
      cat /etc/issue
    fi
    uname -a
    ;;
  "suse")
    cat /etc/SuSE-release
    ;;
  "debian")
    lsb_release -a
    ;;
  "gentoo")
    cat /etc/gentoo-release
    ;;
  "arch")
    cat /etc/os-release
    ;;
  "slackware")
    cat /etc/slackware-version
    ;;
  *)
    if [ -s /etc/issue ]; then
      cat /etc/issue
    else
      echo "Error: Unknown distribution"
      exit 1
    fi
    ;;
  esac
}

# Automatically install the needed support files for this .bashrc file
install_bashrc_support() {
  local dtype
  dtype=$(distribution)

  case $dtype in
  "redhat")
    sudo yum install eza zoxide trash-cli fzf bash-completion neofetch
    ;;
  "suse")
    sudo zypper install eza zoxide trash-cli fzf bash-completion neofetch
    ;;
  "debian")
    sudo apt-get install eza zoxide trash-cli fzf bash-completion neofetch
    # install starship prompt
    curl -sS https://starship.rs/install.sh | sh
    ;;
  "arch")
    yay -S eza zoxide trash-cli fzf bash-completion neofetch starship colorscript-git
    ;;
  "slackware")
    echo "No install support for Slackware"
    ;;
  *)
    echo "Unknown distribution"
    ;;
  esac
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip() {
  # Internal IP Lookup.
  if [ -e /sbin/ip ]; then
    echo -n "Internal IP: "
    /sbin/ip addr show wlan0 | grep "inet " | awk -F: '{print $1}' | awk '{print $2}'
  else
    echo -n "Internal IP: "
    /sbin/ifconfig wlan0 | grep "inet " | awk -F: '{print $1} |' | awk '{print $2}'
  fi

  # External IP Lookup
  echo -n "External IP: "
  curl -s ifconfig.me
}

# git advance
gcom() {
  git add .
  git commit -m "$1"
}

lazyg() {
  git add .
  git commit -m "$1"
  git push
}

### SHOW COLORSCRIPT ON STARTUP ###
colorscript --exec crunchbang-mini

### SETUP STARSHIP PROMPT ###
eval "$(starship init bash)"

### SETUP ZOXIDE ###
eval "$(zoxide init bash)"
