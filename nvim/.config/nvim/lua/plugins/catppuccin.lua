return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
        transparent_background = false,
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
            light = "latte",
            dark = "mocha",
        },
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.05,
        },
        auto_integrations = true,
    },
    specs = {
        {
            "akinsho/bufferline.nvim",
            optional = true,
            opts = function(_, opts)
                if (vim.g.colors_name or ""):find("catppuccin") then
                    opts.highlights = require("catppuccin.special.bufferline").get_theme()
                end
            end,
        },
    },
}
