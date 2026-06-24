return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                pyright = {
                    mason = false,
                },
                basedpyright = {
                    mason = True
                },
            },
        },
    },
}
