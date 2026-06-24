return {
    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                hidden = true,  -- for hidden files
                ignored = true, -- for .gitignore files
                layout = {
                    title = "",
                },
            },
            terminal = {
                shell = "bash",
            },
            image = {
            },
            styles = {
                terminal = {
                }
            },
            lazygit = {
                -- Prevent snacks from injecting its own defaults or preset configs
                configure = false,
            },
        },
    },
}
