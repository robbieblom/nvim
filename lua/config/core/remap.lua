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
vim.keymap.set("n", "<leader>sv", "<C-w>v")        -- split window vertically
vim.keymap.set("n", "<leader>sf", "<C-w>s")        -- split window horizontally (flat)
vim.keymap.set("n", "<leader>se", "<C-w>=")        -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", ":close<CR>")    -- close current split window

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")   -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>to", ":tabn<CR>")     --  go to next tab
vim.keymap.set("n", "<leader>ty", ":tabp<CR>")     --  go to previous tab

-- command mode
vim.keymap.set("n", "<leader>j", ":")  -- enter command mode
vim.keymap.set("v", "<leader>j", ":")  -- enter command mode in visual mode
vim.keymap.set("n", "<leader>k", ":!") -- enter shell command mode
vim.keymap.set("v", "<leader>k", ":!") -- enter shell command mode in visual mode

-- execute current file
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":lua %<CR>")
vim.keymap.set("v", "<leader>x", ":lua %<CR>")

-- quickfix
vim.keymap.set("n", "<leader>co", ":copen<CR>")
vim.keymap.set("v", "<leader>co", ":copen<CR>")
vim.keymap.set("n", "<leader>cc", ":cclose<CR>")
vim.keymap.set("v", "<leader>cc", ":cclose<CR>")
vim.keymap.set("n", "<leader>cn", ":cnext<CR>")
vim.keymap.set("v", "<leader>cn", ":cnext<CR>")
vim.keymap.set("n", "<leader>cp", ":cprev<CR>")
vim.keymap.set("v", "<leader>cp", ":cprev<CR>")

-- lsp
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
