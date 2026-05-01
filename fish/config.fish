# Apple Silicon, Linuxbrew, Intel mac (in that order) — first one that exists wins.
for brew_prefix in /opt/homebrew /home/linuxbrew/.linuxbrew /usr/local
    if test -x "$brew_prefix/bin/brew"
        eval "$($brew_prefix/bin/brew shellenv)"
        break
    end
end
set -gx COPYFILE_DISABLE 1

if status is-interactive
    set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
    set -gx EDITOR nvim
    set -gx VISUAL $EDITOR
    set -gx LESS '--incsearch'
    set -gx PIP_REQUIRE_VIRTUALENV 1

    alias vim nvim
    alias vi nvim
    abbr --add lvim NVIM_APPNAME=lazyvim nvim
    #abbr --add k kubectl

    # Dotfiles root: derive from this file's actual location (resolves through symlinks).
    # Works for local clones (~/dotfiles) and brew installs (#{opt_pkgshare}) alike.
    set -q DOTFILES; or set -gx DOTFILES (path dirname (path dirname (path resolve (status filename))))
    # gruvbox = upstream preset colors (no palette overlay). tokyo | catppuccin | pastel = overlays/palette-<name>.toml
    set -q STARSHIP_THEME; or set -gx STARSHIP_THEME gruvbox

    if test -x "$DOTFILES/starship/build"
        if not "$DOTFILES/starship/build" --theme "$STARSHIP_THEME"
            printf 'warning: failed to build Starship config for theme %s\n' "$STARSHIP_THEME" >&2
        end
    else
        printf 'warning: Starship build helper missing: %s\n' "$DOTFILES/starship/build" >&2
    end

    function starship_transient_rprompt_func
        starship module custom.time_pill
    end
    starship init fish | source
    enable_transience
end
