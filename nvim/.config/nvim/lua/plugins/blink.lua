return {
    {
        "saghen/blink.cmp",
        opts = function(_, opts)
            opts.keymap = {
                preset = "super-tab",
                ["<S-Tab>"] = { "select_next" },
            }
        end,
    },
}
