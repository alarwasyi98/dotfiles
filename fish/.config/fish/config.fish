#        .__
# _____  |  |     FISH SHELL SETUP
# \__  \ |  |     Abdul Hakim (alarwasyi98)
#  / __ \|  |__   https://github.com/alarwasyi98/dotfiles
# (____  /____/   Version: 2.18.1
#      \/

# ENVIRONMENT VARIABLES

# Use -gx (global + exported) for session's variables.
# -Ux only for variables that need to be persistent across sessions (stored on fish_variables).

set -g fish_greeting # Disable fish intro greeting

set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER "nvim +Man!"
set -gx BAT_THEME Dracula
set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"

# XDG Base Directory — Setup once, don't -Ux

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache

# PATH

fish_add_path $HOME/.bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.opencode/bin

# TOOL INITIALIZATION

## Fast Node Manager
fnm env --use-on-cd --shell fish | source

## Starship — put it last of eval so it doesn't get overwritten
starship init fish | source

## Zoxide (smarter cd)
zoxide init fish --cmd cd | source

# FUNCTIONS

## Auto ls in every cd 
function __auto_ls --on-variable PWD
    ls
end

## Go up N directory level: `up 3`
function up
    set limit (test -n "$argv[1]"; and echo $argv[1]; or echo 1)
    set d ""
    for i in (seq 1 $limit)
        set d "../$d"
    end
    cd $d
end

# Yazi file manager with directory tracking
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

## Find text in all files on current dir: `ftext "(args)"`
function ftext
    grep -iIHrn --color=always "$argv[1]" . | less -r
end

## Copy and cd to destination dir
function cpg
    if test -d "$argv[2]"
        cp $argv[1] $argv[2]; and cd $argv[2]
    else
        cp $argv[1] $argv[2]
    end
end

## Move and cd to destination dir
function mvg
    if test -d "$argv[2]"
        mv $argv[1] $argv[2]; and cd $argv[2]
    else
        mv $argv[1] $argv[2]
    end
end

## Make dir and cd inside
function mkdirg
    mkdir -p $argv[1]; and cd $argv[1]
end

## Extract various archive files: `extract file.tar.gz`
function extract
    if test -z "$argv[1]"
        echo "Usage: extract <file>"
        return 1
    end
    for n in $argv
        if test -f "$n"
            switch $n
                case "*.tar.bz2" "*.tbz2"
                    tar xvjf "$n"
                case "*.tar.gz" "*.tgz"
                    tar xvzf "$n"
                case "*.tar.xz" "*.txz"
                    tar xvJf "$n"
                case "*.tar"
                    tar xvf "$n"
                case "*.bz2"
                    bunzip2 "$n"
                case "*.gz"
                    gunzip "$n"
                case "*.rar"
                    unrar x "$n"
                case "*.zip" "*.epub" "*.cbz"
                    unzip "$n"
                case "*.7z"
                    7z x "$n"
                case "*.xz"
                    unxz "$n"
                case "*.z"
                    uncompress "$n"
                case "*"
                    echo "extract: '$n' - format tidak dikenali"
                    return 1
            end
        else
            echo "'$n' - file tidak ditemukan"
            return 1
        end
    end
end

## Check internal and eksternal IP
function whatsmyip
    set internal_ip (ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1)
    set external_ip (curl -s https://ifconfig.me)
    echo "Internal IP: $internal_ip"
    echo "External IP: $external_ip"
end

## Git: add all + commit
function gcom
    git add .
    git commit -m "$argv[1]"
end

## Git: add all + commit + push
function lazyg
    git add .
    git commit -m "$argv[1]"
    git push
end

# ALIASES

## Editor
alias vim='nvim'
alias vi='nvim'
alias svi='sudo nvim'
alias cls='clear'

## Config shortcuts
alias efish='nvim ~/.config/fish/config.fish'
alias reload='source ~/.config/fish/config.fish'
alias showconf='bat ~/.config/fish/config.fish'
alias staredit='nvim $HOME/.config/starship.toml'

## Bring back z command
alias z='cd'

## eza as replacement for ls
alias ls='eza -al --color=always --icons=always --git --group-directories-first'
alias la='eza -a --color=always --icons=always --git --group-directories-first'
alias ll='eza -l --color=always --icons=always --git --group-directories-first'
alias lt='eza -aT --color=always --icons=always --git --group-directories-first'
alias l.='eza -al --color=always --icons=always --group-directories-first ../'
alias l..='eza -al --color=always --icons=always --group-directories-first ../../'
alias l...='eza -al --color=always --icons=always --group-directories-first ../../../'

## Directory Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias bd='cd $OLDPWD'

## General Utilities
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

## Process operation
alias psa='ps auxf'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'
alias topcpu='/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10'

## Searching
alias h='history | grep'
alias f='find . | grep'
alias checkcommand='type -t'

## Disk Operation
alias diskspace='du -S | sort -n -r | more'
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

## fzf — Fish's syntax using () not $() for substitution command
alias cdf='cd (fd -t d | fzf)'
alias fvim='nvim (fzf --preview="bat --color=always {}" --bind shift-up:preview-page-up,shift-down:preview-page-down)'
alias ff='fzf --preview=less --bind shift-up:preview-page-up,shift-down:preview-page-down'

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
alias orphan='sudo pacman -Rns (pacman -Qtdq)' # () benar di Fish

## Arch Linux - Relflector Mirror
alias mirror='sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirrord='sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist'
alias mirrors='sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist'
alias mirrora='sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist'

## GPG
alias gpg-check='gpg2 --keyserver-options auto-key-retrieve --verify'
alias gpg-retrieve='gpg2 --keyserver-options auto-key-retrieve --receive-keys'

## Clipboard (WSL: use clip.exe / powershell.exe as fallback)
if command -v xsel &>/dev/null
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
else
    alias pbcopy='clip.exe'
    alias pbpaste='powershell.exe -command "Get-Clipboard"'
end

## Reboot
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

## Change default login shell
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Log out and log back in to take effect'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Log out and log back in to take effect'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Log out and log back in to take effect'"

## Termbin
alias tb='nc termbin.com 9999'

# STARTUP DISPLAY

colorscript --exec panes
