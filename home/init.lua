-- lots stolen from <https://martinlwx.github.io/en/config-neovim-from-scratch/>



--%%%%%%%%%%%%%%%--
--  C O L O R S  --
--%%%%%%%%%%%%%%%--

local colorscheme = 'ayu'
local is_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not is_ok then
    vim.notify('colorscheme `' .. colorscheme .. '` not found!')
    return
end



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
vim.opt.foldenable = false
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



--%%%%%%%%%%%%%%%%%%%%%%%--
--  C O M P L E T I O N  --
--%%%%%%%%%%%%%%%%%%%%%%%--

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local luasnip = require('luasnip')
local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- Use <C-b/f> to scroll the docs
        ['<C-b>'] = cmp.mapping.scroll_docs( -4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Use <C-k/j> to switch in items
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        -- Use <CR>(Enter) to confirm selection
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        -- A super tab
        -- sourc: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
        ['<Tab>'] = cmp.mapping(function(fallback)
            -- Hint: if the completion menu is visible select next one
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }), -- i - insert mode; s - select mode
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable( -1) then
                luasnip.jump( -1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

  -- Let's configure the item's appearance
  -- source: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
  formatting = {
      -- Set order from left to right
      -- kind: single letter indicating the type of completion
      -- abbr: abbreviation of 'word'; when not empty it is used in the menu instead of 'word'
      -- menu: extra text for the popup menu, displayed after 'word' or 'abbr'
      fields = { 'abbr', 'menu' },

      -- customize the appearance of the completion menu
      format = function(entry, vim_item)
          vim_item.menu = ({
              nvim_lsp = '[Lsp]',
              luasnip = '[Luasnip]',
              buffer = '[File]',
              path = '[Path]',
          })[entry.source.name]
          return vim_item
      end,
  },

  -- Set source precedence
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },    -- For nvim-lsp
      { name = 'luasnip' },     -- For luasnip user
      { name = 'buffer' },      -- For buffer word completion
      { name = 'path' },        -- For path completion
  })
})



--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--  L A N G U A G E   S E R V E R S  --
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--

-- Set different settings for different languages' LSP
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP
--     - on_attach: a lua callback function to run after LSP attaches to a given buffer
local lspconfig = require('lspconfig')

-- Customized on_attach function
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<space>k', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

-- LSP binaries:
lspconfig.bashls.setup({ on_attach = on_attach })
lspconfig.clangd.setup({ on_attach = on_attach })
lspconfig.lua_ls.setup({ on_attach = on_attach, settings = { Lua = {
    diagnostics = { globals = "vim" },
    runtime = { version = "LuaJIT" },
    telemetry = { enable = false },
    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
}}})
lspconfig.ocamllsp.setup({ on_attach = on_attach })
lspconfig.pylsp.setup({ on_attach = on_attach })
lspconfig.rust_analyzer.setup({ on_attach = on_attach, settings = { ["rust-analyzer"] = {
    -- <https://rust-analyzer.github.io/manual.html#nvim-lsp>
    cargo = { buildScripts = { enable = true } },
    imports = { granularity = { group = "module" }, prefix = "self" },
    inlayHints = { closingBraceHints = true },
    procMacro = { enable = true },
}}})

-- Format on save!
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]



--%%%%%%%%%%%%%%%%%%%%%%%--
--  T R E E S I T T E R  --
--%%%%%%%%%%%%%%%%%%%%%%%--

-- <https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim>
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  end
})

