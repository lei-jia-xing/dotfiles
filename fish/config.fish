if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    starship init fish | source

    alias ls 'eza --icons'
    alias ta 'tmux attach -t main 2>/dev/null || tmux new -s main'
    alias ssh 'kitty +kitten ssh'
    direnv hook fish | source
    zoxide init fish | source
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -gx PATH $HOME/.cabal/bin /home/hunter/.ghcup/bin $HOME/.config/emacs/bin $PATH
set -gx PATH $HOME/.cache/.bun/bin $PATH
set -gx PATH $HOME/go/bin $PATH
~/.local/bin/mise activate fish | source
