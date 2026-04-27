eval "$(/opt/homebrew/bin/brew shellenv)"
set -gx COPYFILE_DISABLE 1

# Created by `pipx` on 2022-01-14 22:18:24
export PATH="$PATH:/Users/gkanapathy/.local/bin"

if status is-interactive
    set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
    set -gx EDITOR nvim
    set -gx VISUAL $EDITOR
    set -gx LESS '--incsearch'
    #abbr --add k kubectl
    #abbr --add lazyvim NVIM_APPNAME=lazyvim nvim

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
