-- 4 space for tab everywhere
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

-- titlestring
vim.opt.title = true
vim.opt.titlestring = [[ [%{fnamemodify(getcwd(), ":t")}] %t]]

-- other
vim.opt.wrap = true
vim.opt.spell = false
vim.g.lazyvim_python_lsp = "basedpyright"
vim.diagnostic.enable(false)
vim.g.lazygit_config = false
