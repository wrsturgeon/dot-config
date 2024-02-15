local builtin = require('telescope.builtin')

-- <https://github.com/nvim-telescope/telescope.nvim#file-pickers>
vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- `ff` for "find files"
-- vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>rg', builtin.live_grep, {}) -- `rg` for `ripgrep`
-- vim.keymap.set('n', '<leader>gs', function() builtin.grep_string({ search = vim.fn.input("grep > ") }) end)
