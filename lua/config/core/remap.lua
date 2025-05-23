local vim = vim

vim.g.mapleader = " "
vim.g.maplocalleader = ","

---------------------
-- General Keymaps
---------------------
vim.keymap.set("n", "<leader>e", ":q<CR>")  -- quit
vim.keymap.set("n", "<leader>w", ":w<CR>")  -- save
vim.keymap.set("n", "<leader>W", ":wa<CR>") -- save all
vim.keymap.set("n", "<leader>E", ":qa<CR>") -- quit all

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<ESC>")

-- clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x')

-- increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>") -- increment
vim.keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v")     -- split window vertically
vim.keymap.set("n", "<leader>sf", "<C-w>s")     -- split window horizontally (flat)
vim.keymap.set("n", "<leader>se", "<C-w>=")     -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
--vim.keymap.set("n", "<leader>sh", "<C-w>h") -- move cursor left
--vim.keymap.set("n", "<leader>sl", "<C-w>l") -- move cursor right
--vim.keymap.set("n", "<leader>sj", "<C-w>j") -- move cursor down
--vim.keymap.set("n", "<leader>sk", "<C-w>k") -- move cursor up

vim.keymap.set("n", "<leader>to", ":tabnew<CR>")   -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>")     --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>")     --  go to previous tab

-- command mode
vim.keymap.set("n", "<leader>c", ":")
vim.keymap.set("n", "<leader>C", ":! ")

-- lsp
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })


-- notes
-- vim.keymap.set("n", "<leader>nn", function()
--   -- read from input
--   local input = vim.fn.input("Enter title for literature note: ")
--   vim.cmd(":! note -l " .. input)
--   vim.cmd(":LspRestart")
-- end)
-- vim.keymap.set("n", "<leader>nf", function()
--   -- read from input
--   local input = vim.fn.input("Enter title for fleeting note: ")
--   vim.cmd(":! note -f " .. input)
--   vim.cmd(":LspRestart")
-- end)
-- vim.keymap.set("n", "<leader>nu", function()
--   -- read from input
--   local current = vim.fn.input("Enter current title: ")
--   local new = vim.fn.input("Enter new title: ")
--   vim.cmd(":! note -u " .. current .. " " .. new)
--   vim.cmd(":LspRestart")
-- end)
