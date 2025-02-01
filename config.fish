set -x R_LIBS_USER $HOME/R/library
set -x PATH $PATH $HOME/.cargo/bin
set -x PATH $PATH $HOME/.local/share/nvim/mason/bin

set -x NOXE_DIR $HOME/work_space/notes
set -x NOXE_AUTHOR sqfzy
set -x NOXE_TYPE typ
set -x NOXE_TEMPLATE $NOXE_DIR/noxe_template.yml

# hostip=$(cat /etc/resolv.conf | grep -oP '(?<=nameserver\ ).*')
# export http_proxy="http://${hostip}:10811"
# export https_proxy="http://${hostip}:10811"
# export all_proxy="socks5://${hostip}:10811"

# set -l hostip (ip route show | grep -i default | awk '{ print $3}')
# set -x http_proxy "http://$hostip:7897"
# set -x https_proxy "http://$hostip:7897"
# set -x all_proxy "socks5://$hostip:7897"

if status is-interactive
    # Commands to run in interactive sessions can go here
    oh-my-posh init fish --config ~/.config/fish/themes/sqfzy.omp.json | source
    . /usr/share/autojump/autojump.fish
end

if test -f $HOME/openai_api_key
    set -x OPENAI_API_KEY (cat $HOME/openai_api_key)
end

alias oldls="ls"
alias ls="exa"
alias oldcat="cat"
alias cat="bat"
alias oldgrep="grep"
alias grep="rg"
