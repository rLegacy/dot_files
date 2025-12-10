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

-- bufferline colors
-- vim.api.nvim_set_hl(0, "BufferlineFill", { bg = "#1e1e2f" })
-- vim.api.nvim_set_hl(0, "BufferLineBackground", { fg = "#6c7086" })
-- vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = "#CAA6F7", bold = true })
-- vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { fg = "#cdd6f4" })
