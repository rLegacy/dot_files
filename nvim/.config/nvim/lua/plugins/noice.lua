return {
    "folke/noice.nvim",
    opts = {
        routes = {
            {
                filter = {
                    event = "notify",                  -- Use "notify" instead of "msg_show" to catch toast popups
                    warning = true,                    -- Only target warnings
                    find = "Adapter reported a frame", -- Partial string match
                },
                opts = { skip = true },
            },
        },
    },
}
