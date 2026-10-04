vim.opt.termguicolors = false

if vim.env.SSH_TTY then
  vim.g.clipboard = 'osc52'
end

if vim.g.neovide then
  vim.o.guifont = 'BlexMono Nerd Font,MesloLGS Nerd Font Mono,' .. vim.o.guifont
end
