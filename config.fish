set -x R_LIBS_USER ~/R/library
set -x PATH $PATH ~/.cargo/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
    oh-my-posh init fish --config ~/.config/fish/themes/sqfzy.omp.json | source
    . /usr/share/autojump/autojump.fish
end
