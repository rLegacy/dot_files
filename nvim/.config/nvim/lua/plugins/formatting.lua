return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                html = { "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                typescript = { "prettier" },
                javascript = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                python = { "ruff" },
                lua = {
                    "stylelua",
                    args = {
                        "--indent-width", "4",
                        "--indent-type", "Spaces"
                    }
                },
            },
            formatters = {
                prettier = {
                    prepend_args = {
                        "--tab-width", "4",
                        "--use-tabs", "false"
                    },
                },
            },
        },
    },
}
