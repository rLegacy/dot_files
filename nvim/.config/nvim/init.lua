-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.title = true
vim.opt.titlestring = [[ [%{fnamemodify(getcwd(), ":t")}] %t]]

-- set kitty margin on enter/leave
if vim.env.KITTY_WINDOW_ID then
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.fn.system({ "kitty", "@", "set-spacing", "margin=0" })
        end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            vim.fn.system({ "kitty", "@", "set-spacing", "margin=default" })
        end,
    })
end
