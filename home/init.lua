-- lots stolen from <https://martinlwx.github.io/en/config-neovim-from-scratch/>



--%%%%%%%%%%%%%%%--
--  K E Y M A P  --
--%%%%%%%%%%%%%%%--

local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- switch windows without the extra `C-w`
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- resize windows with `C-[arrow keys]`
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)



--%%%%%%%%%%%%%%%%%--
--  O P T I O N S  --
--%%%%%%%%%%%%%%%%%--

vim.opt.clipboard = 'unnamedplus' -- system clipboard
vim.opt.completeopt = {'menu', 'menuone', 'noselect'} -- completion?
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true -- but... (see smartcase)
vim.opt.incsearch = true -- show search results while typing
vim.opt.mouse = nil -- disable mouse input
vim.opt.number = true -- line numbers
vim.opt.relativenumber = false
vim.opt.shiftwidth = 4
vim.opt.showmode = true
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4



--%%%%%%%%%%%%%%%--
--  C O L O R S  --
--%%%%%%%%%%%%%%%--

local colorscheme = 'ayu'
local is_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not is_ok then
    vim.notify('colorscheme `' .. colorscheme .. '` not found!')
    return
end
