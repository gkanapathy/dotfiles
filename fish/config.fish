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

    # Dotfiles root (override if repo lives elsewhere)
    set -q DOTFILES; or set -gx DOTFILES "$HOME/dotfiles"
    # gruvbox = upstream preset colors (no palette overlay). tokyo | catppuccin | pastel = overlays/palette-<name>.toml
    set -q STARSHIP_THEME; or set -gx STARSHIP_THEME gruvbox

    set -l _palette "$DOTFILES/starship/overlays/palette-$STARSHIP_THEME.toml"
    if test "$STARSHIP_THEME" = gruvbox
        starship preset gruvbox-rainbow | uv run --directory "$DOTFILES/starship" python "$DOTFILES/starship/build_preset.py" --layout "$DOTFILES/starship/overlays/layout.toml" --out "$HOME/.config/starship.toml"
    else if test -f "$_palette"
        starship preset gruvbox-rainbow | uv run --directory "$DOTFILES/starship" python "$DOTFILES/starship/build_preset.py" --layout "$DOTFILES/starship/overlays/layout.toml" --palette "$_palette" --out "$HOME/.config/starship.toml"
    else
        starship preset gruvbox-rainbow | uv run --directory "$DOTFILES/starship" python "$DOTFILES/starship/build_preset.py" --layout "$DOTFILES/starship/overlays/layout.toml" --out "$HOME/.config/starship.toml"
    end

    function starship_transient_rprompt_func
        starship module time
    end
    starship init fish | source
    enable_transience
end
