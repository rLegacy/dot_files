return {
    {
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
                enabled = true,    -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.05, -- percentage of the shade to apply to the inactive window
            },
        },
    },
}
