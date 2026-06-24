return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
            {
                "<leader>du",
                function()
                    local dapui = require("dapui")
                    local is_open = false

                    -- Check for any visible DAP-UI windows or REPL
                    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        local ft = vim.bo[buf].filetype
                        if ft:find("dapui") or ft == "dap-repl" then
                            is_open = true
                            break
                        end
                    end

                    if is_open then
                        dapui.close()
                        -- Explicitly close the REPL if it's still hanging around
                        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].filetype == "dap-repl" then
                                vim.api.nvim_win_close(win, true)
                            end
                        end
                    else
                        dapui.open(1)                    -- Open only sidebars by default
                        vim.api.nvim_command("wincmd p") -- Focus fix
                    end
                end,
                desc = "Dap UI: Smart Toggle (Includes REPL Cleanup)",
            },
            {
                "<leader>tI",
                function()
                    require("dapui").toggle(2) -- Toggle the bottom Scopes/Watches layout
                end,
                desc = "Toggle Scopes and Watches",
            },
        },
        opts = {
            force_focus = false,
            layouts = {
                {
                    elements = {
                        { id = "repl", size = 1 },
                    },
                    size = 15, -- Height for the output section
                    position = "bottom",
                },
                {
                    elements = {
                        { id = "scopes",  size = 0.8 }, -- 80% width
                        { id = "watches", size = 0.2 }, -- 20% width
                    },
                    position = "bottom",
                    size = 10, -- Height of the bottom tray
                },
            },
            -- Floating window settings for <leader>ti
            floating = {
                max_height = nil,
                max_width = nil,
                border = "rounded",
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
        },
        config = function(_, opts)
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup(opts)

            -- PERSISTENCE & FOCUS FIX (Merged)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                local main_win = vim.api.nvim_get_current_win()
                -- Open ONLY the first layout (side panes)
                dapui.open(1)

                vim.schedule(function()
                    if main_win and vim.api.nvim_win_is_valid(main_win) then
                        vim.api.nvim_set_current_win(main_win)
                    end
                end)
            end

            -- BREAKPOINT TRIGGER: Auto-open Layout 2 (Bottom Tray)
            dap.listeners.after.event_stopped["dapui_config"] = function()
                dapui.open(2)
            end

            -- Prevent LazyVim from auto-closing the UI
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close(2)
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close(2)
            end

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "dap-repl",
                callback = function(args)
                    local bufnr = args.buf

                    -- Fix path recognition
                    vim.cmd([[setlocal isfname+=44,32,34]])

                    -- Auto-scroll
                    if not vim.b[bufnr].dap_scroll_attached then
                        vim.api.nvim_buf_attach(bufnr, false, {
                            on_lines = function()
                                vim.schedule(function()
                                    if not vim.api.nvim_buf_is_valid(bufnr) then return end
                                    local wins = vim.fn.win_findbuf(bufnr)
                                    for _, win in ipairs(wins) do
                                        local last_line = vim.api.nvim_buf_line_count(bufnr)
                                        pcall(vim.api.nvim_win_set_cursor, win, { last_line, 0 })
                                    end
                                end)
                            end,
                        })
                        vim.b[bufnr].dap_scroll_attached = true
                    end

                    -- Docker-to-Local path mapping with Primary Window targeting
                    vim.keymap.set("n", "<CR>", function()
                        local line = vim.api.nvim_get_current_line()
                        local curr_win = vim.api.nvim_get_current_win() -- Get current window (potentially floating)
                        local docker_root = "/var/www/isc/infoscout"
                        local local_root = vim.fn.expand("~/Documents/development/projects/infoscout")

                        -- Regex Pattern 1: File "path", line XX
                        local path, line_nr = line:match('File "(.-)", line (%d+)')
                        -- Regex Pattern 2: /path/to/file.py:XX
                        if not path then
                            path, line_nr = line:match('([%w%._/-]+%.py):(%d+)')
                        end

                        if path then
                            local local_path = path:gsub("^" .. docker_root, local_root)

                            -- FIND PRIMARY WINDOW: Look for a window that isn't a DAP-UI element
                            local target_win = nil
                            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                                local wbuf = vim.api.nvim_win_get_buf(win)
                                local wft = vim.bo[wbuf].filetype
                                if not wft:find("dapui") and wft ~= "dap-repl" then
                                    target_win = win
                                    break
                                end
                            end

                            -- Execute the jump in the target window
                            if target_win then
                                vim.api.nvim_set_current_win(target_win)
                                vim.cmd("edit " .. local_path)
                                if line_nr then
                                    pcall(vim.api.nvim_win_set_cursor, target_win, { tonumber(line_nr), 0 })
                                end
                                vim.cmd("normal! zvzz")

                                -- If the REPL was in a floating window, close it now
                                local win_cfg = vim.api.nvim_win_get_config(curr_win)
                                if win_cfg.relative ~= "" then
                                    vim.api.nvim_win_close(curr_win, true)
                                end
                            else
                                -- Fallback: open in a vertical split if no main window found
                                vim.cmd("vsplit " .. local_path)
                            end
                        else
                            pcall(vim.cmd, "normal! gf")
                        end
                    end, { buffer = bufnr, desc = "Jump to Local File in Main Window" })
                end,
            })
        end,
    },
    {
        "m00qek/baleia.nvim",
        config = function()
            vim.g.baleia = require("baleia").setup({ line_starts_at = 3 }) -- Adjust for REPL prompt

            -- Automatically colorize the REPL when it opens
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "dap-repl",
                callback = function(ev)
                    vim.g.baleia.automatically(ev.buf)
                end,
            })
        end,
    }
}
