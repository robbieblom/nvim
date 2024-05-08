return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    require("dapui").setup()
    require('dap-python').setup('~/.config/nvim/.debuggers/.python/debugpy/bin/python')

    local dap, dapui = require("dap"), require("dapui")

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = "Market Overview Tests",
        module = 'pytest',
        args = {
          "test/test_MarketOverview.py"
        }
      },
      {
        type = 'python',
        request = 'launch',
        name = "Occupancy Tests",
        module = 'pytest',
        args = {
          "test/test_Occupancy.py"
        }
      },
      {
        type = 'python',
        request = 'launch',
        name = "Prep Tests",
        module = 'pytest',
        args = {
          "test/test_Prep.py"
        }
      },
    }

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end


    vim.keymap.set("n", "<Leader>dt", function() require('dapui').toggle() end)
    vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>")
    vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
    vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>")
    vim.keymap.set("n", "<Leader>di", ":DapStepInto<CR>")
    vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
    vim.keymap.set('n', '<Leader>dr', function() require('dap').restart() end)
    vim.keymap.set('n', '<Leader>dl', function() require('dap').list_breakpoints() end)
    vim.keymap.set('n', '<Leader>dd', function() require('dap').clear_breakpoints() end)
    vim.keymap.set('n', '<Leader>dui', ":lua require('dapui').open({reset=true})<CR>")
  end,
}
