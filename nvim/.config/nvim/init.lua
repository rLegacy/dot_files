-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

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
