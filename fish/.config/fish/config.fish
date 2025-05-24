#        .__
# _____  |  |     FRIENDLY INTERACTIVE SHELL SETUP
# \__  \ |  |     Abdul Hakim (alarwasyi98)
#  / __ \|  |__   https://github.com/alarwasyi98
# (____  /____/
#      \/

### EXPORTS ###
set fish_greeting # Supresses fish's intro message
set TERM xterm-256color # Sets the terminal type
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux PAGER less
set -Ux MANPAGER "nvim +Man!"
# set -Ux PATH $HOME/.local/bin /usr/local/bin $PATH
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux XDG_DATA_HOME $HOME/.local/share
set -Ux FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"

###  SOURCES ###
# source ~/.config/fish/auto-Hypr.fish # WARNING! FAIL TO LAUNCH HYPR

### I DONT KNOW WHAT IT IS ##
function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
end

if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
    cat ~/.cache/ags/user/generated/terminal/sequences.txt
end

## END ##

### ALIASES ###
alias cls='clear'

# fish
alias efish=' nvim ~/.config/fish/config.fish'
alias reload='source ~/.config/fish/config.fish'
alias showconf='bat --theme=Dracula ~/.config/fish/config.fish'

# xsel
alias pbcopy "xsel --clipboard --input"
alias pbpaste "xsel --clipboard --output"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Changing "ls" to "eza"
alias ls='eza -al --color=always --icons=always --git --group-directories-first' # my preferred listing
alias la='eza -a --color=always --icons=always --git --group-directories-first' # all files and dirs
alias ll='eza -l --color=always --icons=always --git --group-directories-first' # long format
alias lt='eza -aT --color=always --icons=always --git --group-directories-first' # tree listing
alias l.='eza -a | egrep "^\."'
alias l.='eza -al --color=always --icons=always --group-directories-first ../' # ls on the PARENT directory
alias l..='eza -al --color=always --icons=always --group-directories-first ../../' # ls on directory 2 levels up
alias l...='eza -al --color=always --icons=always --group-directories-first ../../../' # ls on directory 3 levels up

# pacman and yay
alias pacsyu='sudo pacman -Syu' # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu' # Refresh pkglist & update standard pkgs
alias parsua='paru -Sua --noconfirm' # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm' # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck' # remove pacman lock
alias orphan='sudo pacman -Rns (pacman -Qtdq)' # remove orphaned packages (DANGEROUS!)

# adding flags
alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB
alias grep='grep --color=auto' # colorize output (good for log files)

# git
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
alias gla='git log --oneline --graph --all'

# fzf
alias cdf='cd $(fd -t d | fzf)' # fd-find and fzf needs to be preinstalled
alias fvim='nvim $(fzf --preview="bat --color=always {}" --bind shift-up:preview-page-up,shift-down:preview-page-down)' # nvim, bat and fzf needs to be preinstalled
# alias ff='fzf --preview=less --bind shift-up:preview-page-up,shift-down:preview-page-down)'

# change your default USER shell
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Log out and log back in for change to take effect.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Log out and log back in for change to take effect.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Log out and log back in for change to take effect.'"

### FUNCTIONS ###

# IP Address Lookup
function whatsmyip
    # Get internal IP (local network IP)
    set internal_ip (ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1)

    # Get external IP (public IP) by querying an external service
    set external_ip (curl -s https://ifconfig.me)

    echo "Internal IP: $internal_ip"
    echo "External IP: $external_ip"
end

# Override `cd` to auto-list with `la`
function cd
    if test (count $argv) -gt 0
        builtin cd $argv; and la
    else
        builtin cd ~; and la
    end
end

# Override `z` from zoxide to auto-list with `la`
function z
    command z $argv; and la
end

### SHOW COLORSCRIPT ON STARTUP ###
colorscript --exec alpha

### SETUP STARSHIP PROMPT ###
starship init fish | source

### SETUP ZOXIDE ###
zoxide init fish | source
