return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = false,
    version = false, -- Never set this value to "*"! Never!
    opts = {
        instructions_file = "avante.md",
        provider = "litellm",
        providers = {
            -- Hide all default providers from model selector
            claude = { hide_in_model_selector = true },
            openai = { hide_in_model_selector = true },
            azure = { hide_in_model_selector = true },
            gemini = { hide_in_model_selector = true },
            cohere = { hide_in_model_selector = true },
            copilot = { hide_in_model_selector = true },
            bedrock = { hide_in_model_selector = true },
            ollama = { hide_in_model_selector = true },
            vertex_claude = { hide_in_model_selector = true },
            watsonx_code_assistant = { hide_in_model_selector = true },
            -- Custom provider with multiple models
            litellm = {
                __inherited_from = "openai",
                endpoint = "https://engineroomapi.scrippsnet.com",
                model = "claude-sonnet-4-5",
                api_key_name = "AVANTE_API_KEY",
                hide_in_model_selector = false,
                model_names = {
                    "claude-sonnet-4-5",
                    "claude-opus-4-5",
                    "gpt-5",
                    "gemini-3-pro"
                },
            },
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "hrsh7th/nvim-cmp",  -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",  -- for file_selector provider fzf
        "folke/snacks.nvim", -- for input provider snacks
    },
}
