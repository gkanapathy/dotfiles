vim.opt.termguicolors = false

if vim.env.SSH_TTY then
  vim.g.clipboard = 'osc52'
elseif vim.fn.has('mac') == 1 then
  vim.opt.clipboard:append('unnamedplus')
end

if vim.g.neovide then
  vim.o.guifont = 'BlexMono Nerd Font,MesloLGS Nerd Font Mono,' .. vim.o.guifont

  if vim.fn.has('mac') == 1 then
    vim.keymap.set({ 'n', 'i', 'v', 'c', 't' }, '<D-v>', function()
      vim.api.nvim_paste(vim.fn.getreg('+'), true, -1)
    end, { silent = true, desc = 'Paste from system clipboard' })

    vim.keymap.set('x', '<D-c>', '"+y', { silent = true, desc = 'Copy to system clipboard' })
    vim.keymap.set('x', '<D-x>', '"+d', { silent = true, desc = 'Cut to system clipboard' })
    vim.keymap.set('n', '<D-z>', 'u', { silent = true, desc = 'Undo' })
    vim.keymap.set('i', '<D-z>', '<C-o>u', { silent = true, desc = 'Undo' })
    vim.keymap.set('x', '<D-z>', '<Esc>u', { silent = true, desc = 'Undo' })
  end
end

vim.pack.add({
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
})

vim.cmd.colorscheme('catppuccin')
