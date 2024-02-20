return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  -- opts = {},
  config = function()
    require("tokyonight").setup({
      on_highlights = function(hl, c)
        hl.DapUIRestart = { fg = c.green }
        hl.DapUIScope = { fg = c.blue }
        hl.DapUIType = { fg = c.magenta }
        hl.DapUIModifiedValue = { fg = c.blue }
        hl.DapUIDecoration = { fg = c.blue }
        hl.DapUIThread = { fg = c.green }
        hl.DapUIStoppedThread = { fg = c.blue }
        hl.DapUISource = { fg = c.magenta }
        hl.DapUILineNumber = { fg = c.blue }
        hl.DapUIFloatBorder = { fg = c.blue }
        hl.DapUIWatchesEmpty = { fg = c.red }
        hl.DapUIWatchesValue = { fg = c.green }
        hl.DapUIWatchesError = { fg = c.red }
        hl.DapUIBreakpointsPath = { fg = c.blue }
        hl.DapUIBreakpointsInfo = { fg = c.green }
        hl.DapUIBreakpointsCurrentLine = { fg = c.green }
        hl.DapUIBreakpointsDisabledLine = { fg = c.black }
        hl.DapUIStepOver = { fg = c.blue }
        hl.DapUIStepInto = { fg = c.blue }
        hl.DapUIStepBack = { fg = c.blue }
        hl.DapUIStepOut = { fg = c.blue }
        hl.DapUIStop = { fg = c.red }
        hl.DapUIPlayPause = { fg = c.green }
        hl.DapUIRestart = { fg = c.green }
        hl.DapUIUnavailable = { fg = c.black }
        hl.DapUIWinSelect = { fg = c.blue }
      end
    })
  end,
}
