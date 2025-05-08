return {}
-- return {
--   "mfussenegger/nvim-dap",
--   dependencies = {
--     "mfussenegger/nvim-dap-python",
--     "rcarriga/nvim-dap-ui",
--   },
--   config = function()
--     local dap, dap_python, dapui = require("dap"), require('dap-python'), require("dapui")

--     dap_python.setup()
--     -- dap_python.setup('~/.config/nvim/.debuggers/.python/debugpy/bin/python')
--     dapui.setup()

--     table.insert(dap.configurations.python, {
--       type = 'python',
--       request = 'launch',
--       name = "main",
--       program = "main.py",
--       justMyCode = false
--     })
--     table.insert(dap.configurations.python, {
--       type = 'python',
--       request = 'launch',
--       name = "tests",
--       module = 'pytest',
--       args = {
--         "--basetemp=test/temp",
--         "-m run"
--       },
--       -- justMyCode = false
--     })

--     dap.listeners.before.attach.dapui_config = function()
--       dapui.open()
--     end
--     dap.listeners.before.launch.dapui_config = function()
--       dapui.open()
--     end
--     dap.listeners.before.event_terminated.dapui_config = function()
--       dapui.close()
--     end
--     dap.listeners.before.event_exited.dapui_config = function()
--       dapui.close()
--     end


--     vim.keymap.set("n", "<Leader>dt", function() require('dapui').toggle() end)
--     vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>")
--     vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
--     vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>")
--     vim.keymap.set("n", "<Leader>di", ":DapStepInto<CR>")
--     vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
--     vim.keymap.set('n', '<Leader>dr', function() require('dap').restart() end)
--     vim.keymap.set('n', '<Leader>dl', function() require('dap').list_breakpoints() end)
--     vim.keymap.set('n', '<Leader>dd', function() require('dap').clear_breakpoints() end)
--     vim.keymap.set('n', '<Leader>dui', ":lua require('dapui').open({reset=true})<CR>")
--   end,
-- }
