return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = { "markdown", "Avante" },
        quote = { repeat_linebreak = true },
        win_options = {
            showbreak = {
                default = '',
                rendered = '  ',
            },
            breakindent = {
                default = false,
                rendered = true,
            },
            breakindentopt = {
                default = '',
                rendered = '',
            },
        },
        code = {
            enabled = true
        },
        checkbox = {
            enabled = true
        },
        heading = {
            enabled = true,
            render_modes = false,
            atx = true,
            setext = true,
            sign = true,
            icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
            position = 'overlay',
            signs = { '󰫎 ' },
            width = 'full',
            left_margin = 0,
            left_pad = 0,
            right_pad = 0,
            min_width = 0,
            border = false,
            border_virtual = false,
            border_prefix = false,
            above = '▄',
            below = '▀',
            backgrounds = {
                'RenderMarkdownH1Bg',
                'RenderMarkdownH2Bg',
                'RenderMarkdownH3Bg',
                'RenderMarkdownH4Bg',
                'RenderMarkdownH5Bg',
                'RenderMarkdownH6Bg',
            },
            foregrounds = {
                'RenderMarkdownH1',
                'RenderMarkdownH2',
                'RenderMarkdownH3',
                'RenderMarkdownH4',
                'RenderMarkdownH5',
                'RenderMarkdownH6',
            },
            custom = {},
        },
        indent = {
            enabled = true
        },
        link = {
            enabled = true
        },
        bullet = {
            enabled = true
        },
        paragraph = {
            enabled = true
        },
        sign = {
            enabled = true
        }
    },
}
