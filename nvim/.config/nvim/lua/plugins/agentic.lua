return {
    "carlos-algms/agentic.nvim",

    --- @type agentic.PartialUserConfig
    opts = {
        -- Any ACP-compatible provider works. Built-in: "claude-agent-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "copilot-acp" | "auggie-acp" | "mistral-vibe-acp" | "cline-acp" | "goose-acp" | "kiro-acp" | "pi-acp"
        provider = "claude-agent-acp", -- setting the name here is all you need to get started
    },

    -- these are just suggested keymaps; customize as desired
    keys = {
        -- whichkey group
        { "<leader>a", group = "agentic" },

        {
            "<leader>at",
            function() require("agentic").toggle() end,
            mode = { "n", "v", "i" },
            desc = "Toggle chat",
        },
        {
            "<leader>aa",
            function() require("agentic").add_selection_or_file_to_context() end,
            mode = { "n", "v" },
            desc = "Add file/selection to context",
        },
        {
            "<leader>an",
            function() require("agentic").new_session() end,
            mode = { "n", "v", "i" },
            desc = "New session",
        },
        {
            "<leader>ar",
            function() require("agentic").restore_session() end,
            mode = { "n", "v", "i" },
            desc = "Restore session",
            silent = true,
        },
        {
            "<leader>ad",
            function() require("agentic").add_current_line_diagnostics() end,
            mode = { "n" },
            desc = "Add line diagnostics",
        },
        {
            "<leader>aD",
            function() require("agentic").add_buffer_diagnostics() end,
            mode = { "n" },
            desc = "Add buffer diagnostics",
        },
    },
}
