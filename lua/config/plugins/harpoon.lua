return {}
-- return {
--   "ThePrimeagen/harpoon",
--   branch = "harpoon2",
--   dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim' },
--   config = function()
--     local harpoon = require("harpoon")
--     harpoon:setup()

--     -- basic telescope configuration
--     local conf = require("telescope.config").values
--     local function toggle_telescope(harpoon_files)
--       local file_paths = {}
--       for _, item in ipairs(harpoon_files.items) do
--         table.insert(file_paths, item.value)
--       end

--       require("telescope.pickers").new({}, {
--         prompt_title = "Harpoon",
--         finder = require("telescope.finders").new_table({
--           results = file_paths,
--         }),
--         previewer = conf.file_previewer({}),
--         sorter = conf.generic_sorter({}),
--       }):find()
--     end

--     vim.keymap.set("n", "<leader>hm", function() toggle_telescope(harpoon:list()) end,
--       { desc = "Open harpoon window" })

--     -- Toggle previous & next buffers stored within Harpoon list
--     vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
--     vim.keymap.set("n", "<leader>hc", function() harpoon:list():clear() end)
--     vim.keymap.set("n", "<leader>hr", function() harpoon:list():remove() end)
--     vim.keymap.set("n", "<leader>hr1", function() harpoon:list():removeAt(1) end)
--     vim.keymap.set("n", "<leader>hr2", function() harpoon:list():removeAt(2) end)
--     vim.keymap.set("n", "<leader>hr3", function() harpoon:list():removeAt(3) end)
--     vim.keymap.set("n", "<leader>hr4", function() harpoon:list():removeAt(4) end)

--     vim.keymap.set("n", "<leader>hf1", function() harpoon:list():select(1) end)
--     vim.keymap.set("n", "<leader>hf2", function() harpoon:list():select(2) end)
--     vim.keymap.set("n", "<leader>hf3", function() harpoon:list():select(3) end)
--     vim.keymap.set("n", "<leader>hf4", function() harpoon:list():select(4) end)

--     -- Toggle previous & next buffers stored within Harpoon list
--     vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
--     vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
--   end
-- }
