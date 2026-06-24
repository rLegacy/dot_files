return {
    {
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap", "folke/which-key.nvim" },
        keys = {
            -- Run Single Method or Class
            {
                "<leader>tt",
                function()
                    -- Get the current line number (0-indexed for TS)
                    local current_row = vim.api.nvim_win_get_cursor(0)[1] - 1

                    -- Pass the row to the target finder
                    local target, node, node_name, rel_path = _G.get_python_test_target(current_row)

                    local label = "File"
                    if node then
                        label = (node:type() == "class_definition") and "Class" or "Method"

                        -- This moves the cursor and view to the start of the detected node
                        local start_row = node:range()
                        vim.api.nvim_win_set_cursor(0, { start_row + 1, 0 })
                        vim.api.nvim_command("normal! zt")
                    end

                    _G.run_python_docker_test(target, label .. ": " .. (node_name or rel_path))
                end,
                desc = "Run Selected Test (Based on Line)",
            },
            -- Run Buffer
            {
                "<leader>tb",
                function()
                    local rel_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
                    local target = "/var/www/isc/infoscout/" .. rel_path
                    _G.run_python_docker_test(target, "File: " .. rel_path)
                end,
                desc = "Run Current Buffer Tests",
            },
            -- Run Previous
            {
                "<leader>tp",
                function()
                    local last_run = vim.fn.getreg("p")
                    if last_run == "" then return end
                    _G.run_python_docker_test(last_run, "Previous Run")
                end,
                desc = "Run Previous Tests 'p'",
            },
            -- Edit Previous
            {
                "<leader>tP",
                function()
                    local buf = vim.api.nvim_create_buf(false, true)
                    local content = vim.fn.getreg("p")
                    -- Split register into lines for the buffer
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))

                    vim.api.nvim_open_win(buf, true, {
                        relative = "editor",
                        width = 100,
                        height = 10,
                        row = (vim.o.lines - 10) / 2,
                        col = (vim.o.columns - 100) / 2,
                        style = "minimal",
                        border = "rounded",
                        title = " Edit Test Targets (One Per Line) "
                    })

                    vim.api.nvim_create_autocmd("BufHidden", {
                        buffer = buf,
                        once = true,
                        callback = function()
                            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                            -- Filter out empty lines and join with newline
                            local filtered = {}
                            for _, l in ipairs(lines) do if l ~= "" then table.insert(filtered, l) end end
                            vim.fn.setreg("p", table.concat(filtered, "\n"))
                            vim.notify("Register 'p' updated!")
                        end,
                    })
                end,
                desc = "Edit Previous Tests 'p'",
            },
            -- Inspect
            {
                "<leader>ti",
                function()
                    require("dapui").eval(nil,
                        { context = "repl", enter = true, width = 100, height = 30, position = "center" })
                end,
                desc = "Inspect",
            },
            -- Add method/class to 'l' register
            {
                "<leader>ta",
                function()
                    local current_row = vim.api.nvim_win_get_cursor(0)[1] - 1
                    local target, _, node_name, _ = _G.get_python_test_target(current_row)
                    local current_reg = vim.fn.getreg("l")

                    -- Split the register into a list of lines to check for EXACT matches
                    local staged_tests = vim.split(current_reg, "\n", { trimempty = true })
                    local is_duplicate = false
                    for _, staged in ipairs(staged_tests) do
                        if staged == target then
                            is_duplicate = true
                            break
                        end
                    end

                    if is_duplicate then
                        vim.notify("Already staged in 'l': " .. node_name)
                        return
                    end

                    local new_content = current_reg == "" and target or (current_reg .. "\n" .. target)
                    vim.fn.setreg("l", new_content)

                    local count = #vim.split(new_content, "\n", { trimempty = true })
                    vim.notify("Staged: " .. node_name .. " (Total: " .. count .. ")")
                end,
                desc = "Add Method/Class to List 'l'",
            },
            -- Run tests in 'l' Register
            {
                "<leader>tl",
                function()
                    local staged = vim.fn.getreg("l")
                    if staged == "" then
                        vim.notify("Register 'l' is empty!", vim.log.levels.WARN)
                        return
                    end
                    _G.run_python_docker_test(staged, "custom test list 'l'")
                end,
                desc = "Run List 'l'",
            },
            -- Edit 'l' Register
            {
                "<leader>tL",
                function()
                    local buf = vim.api.nvim_create_buf(false, true)
                    local content = vim.fn.getreg("l")
                    -- Split by newline to populate the buffer lines
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n", { trimempty = true }))

                    vim.api.nvim_open_win(buf, true, {
                        relative = "editor",
                        width = 100,
                        height = 10,
                        row = (vim.o.lines - 10) / 2,
                        col = (vim.o.columns - 100) / 2,
                        style = "minimal",
                        border = "rounded",
                        title = " Edit List 'l'"
                    })

                    vim.api.nvim_create_autocmd("BufHidden", {
                        buffer = buf,
                        once = true,
                        callback = function()
                            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                            local filtered = {}
                            for _, l in ipairs(lines) do if l ~= "" then table.insert(filtered, l) end end
                            vim.fn.setreg("l", table.concat(filtered, "\n"))
                            vim.notify("Register 'l' updated!")
                        end,
                    })
                end,
                desc = "Edit List 'l'",
            },
            -- Smart 90% Float
            {
                "<leader>tf",
                function()
                    local dap = require("dap")
                    local dapui = require("dapui")
                    local width = math.floor(vim.o.columns * 0.9)
                    local height = math.floor(vim.o.lines * 0.9)
                    local row = math.floor((vim.o.lines - height) / 2)
                    local col = math.floor((vim.o.columns - width) / 2)

                    -- ACTIVE SESSION: Prompt for choice
                    if dap.session() then
                        vim.ui.select({ "scopes", "repl", "watches", "stacks" }, {
                            prompt = "Select Active Debug Element:",
                        }, function(choice)
                            if choice then
                                dapui.float_element(choice, {
                                    width = width,
                                    height = height,
                                    enter = true,
                                    position = "center",
                                })
                            end
                        end)
                        return
                    end

                    -- NO SESSION: Manual Buffer Search (Bypasses DAP-UI warning)
                    local repl_buf = nil
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.bo[buf].filetype == "dap-repl" then
                            repl_buf = buf
                            break
                        end
                    end

                    if repl_buf and vim.api.nvim_buf_is_valid(repl_buf) then
                        local float_win = vim.api.nvim_open_win(repl_buf, true, {
                            relative = "editor",
                            width = width,
                            height = height,
                            row = row,
                            col = col,
                            border = "rounded",
                            title = " REPL History (Post-Mortem) ",
                            title_pos = "center",
                        })

                        -- KEYMAP FOR FLOATING WIN: Close on Escape or 'q'
                        vim.keymap.set("n", "<Esc>", function()
                            if vim.api.nvim_win_is_valid(float_win) then
                                vim.api.nvim_win_close(float_win, true)
                            end
                        end, { buffer = repl_buf, silent = true, nowait = true })

                        -- Auto-scroll to bottom of logs
                        vim.cmd("normal! G")
                    else
                        vim.notify("No active session or REPL history found.", vim.log.levels.WARN)
                    end
                end,
                desc = "Float DAP UI",
            },
            -- Add buffer to 'l' register
            {
                "<leader>tA",
                function()
                    local rel_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
                    local target = "/var/www/isc/infoscout/" .. rel_path
                    local current_reg = vim.fn.getreg("l")

                    -- Prevent duplicates
                    if string.find(current_reg, target, 1, true) then
                        vim.notify("File already staged in 'l'")
                        return
                    end

                    -- Add with newline if buffer isn't empty
                    local new_content = current_reg == "" and target or (current_reg .. "\n" .. target)
                    vim.fn.setreg("l", new_content)

                    local count = #vim.split(new_content, "\n", { trimempty = true })
                    vim.notify("Staged File: " .. rel_path .. " (Total: " .. count .. ")")
                end,
                desc = "Add File List to 'l'",
            },
        },
        config = function()
            require("which-key").add({ { "<leader>t", group = "test" } })

            -- Bind debugpy, announce readiness, THEN block for the client.
            -- listen() returns once the socket is accepting connections, so the
            -- printed sentinel is a precise "safe to attach" signal. We must not
            -- probe the port to detect this -- debugpy accepts a single client,
            -- and a probe would consume it, so we attach exactly once on the
            -- sentinel instead.
            local debugpy_bootstrap = table.concat({
                "import sys, debugpy",
                "debugpy.listen(('0.0.0.0', 5678))",
                "print('DEBUGPY_LISTENING', flush=True)",
                "debugpy.wait_for_client()",
                "import pytest",
                "sys.exit(pytest.main(sys.argv[1:]))",
            }, "\n")

            _G.run_python_docker_test = function(target_str, notify_msg)
                local dap = require("dap")
                dap.terminate()
                vim.fn.setreg("p", target_str)

                -- Split by newline to get arguments for pytest
                local target_list = vim.split(target_str, "\n", { trimempty = true })

                vim.notify("Running: " .. notify_msg)

                -- keep the pipe open so we can watch for the sentinel.
                -- -Xfrozen_modules=off so debugpy doesn't miss breakpoints in
                -- frozen stdlib modules (Python 3.12+).
                local cmd = {
                    "docker", "compose", "exec", "-T", "web",
                    "python3", "-Xfrozen_modules=off", "-c", debugpy_bootstrap,
                    "--color=yes", "-s",
                }
                -- Append all targets (passed through to pytest.main via argv)
                for _, t in ipairs(target_list) do table.insert(cmd, t) end

                local attached = false
                local function attach()
                    if attached then return end
                    attached = true
                    dap.run({
                        type = "python",
                        request = "attach",
                        name = "Docker: " .. notify_msg,
                        connect = { host = "127.0.0.1", port = 5678 },
                        pathMappings = { { localRoot = vim.fn.getcwd(), remoteRoot = "/var/www/isc/infoscout" } },
                        justMyCode = true,
                        console = "internalConsole",
                        redirectOutput = true,
                    })
                end

                vim.system(cmd, {
                    text = true,
                    stdout = function(_, data)
                        if data and not attached and data:find("DEBUGPY_LISTENING", 1, true) then
                            vim.schedule(attach)
                        end
                    end,
                }, function(obj)
                    -- Never saw the sentinel: surface why instead of hanging.
                    if not attached then
                        vim.schedule(function()
                            vim.notify(
                                "debugpy never reported listening (exit "
                                .. tostring(obj.code) .. ")\n" .. (obj.stderr or ""),
                                vim.log.levels.ERROR
                            )
                        end)
                    end
                end)
            end

            _G.get_python_test_target = function(row)
                -- If row is provided, use it (0-indexed); otherwise, default to cursor
                local node = row
                    and vim.treesitter.get_node({ pos = { row, 0 } })
                    or vim.treesitter.get_node()

                local target_node, method_name, class_name = nil, nil, nil
                local curr = node
                while curr do
                    local type = curr:type()
                    if type == "function_definition" then
                        target_node = target_node or curr
                        for i = 0, curr:child_count() - 1 do
                            local child = curr:child(i)
                            if child:type() == "identifier" then
                                method_name = vim.treesitter.get_node_text(child, 0)
                            end
                        end
                    elseif type == "class_definition" then
                        target_node = target_node or curr
                        for i = 0, curr:child_count() - 1 do
                            local child = curr:child(i)
                            if child:type() == "identifier" then
                                class_name = vim.treesitter.get_node_text(child, 0)
                            end
                        end
                    end
                    curr = curr:parent()
                end

                local rel_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
                local target = "/var/www/isc/infoscout/" .. rel_path
                local display_name = rel_path

                if class_name then target = target .. "::" .. class_name end
                if method_name then
                    target = target .. "::" .. method_name
                    display_name = method_name
                elseif class_name then
                    display_name = class_name
                end

                return target, target_node, display_name, rel_path
            end

            require("dap").adapters.python = { type = "server", host = "127.0.0.1", port = 5678 }
        end,
    },
}
