-- YO: NOTE: `vi(` (and similarly for different open/close characters) selects everything in parentheses!!!!!
-- And `%` switches between opening and closing whatevers
-- both stolen from <https://superuser.com/questions/463334>

--%%%%%%%%%%%%%%%--
--  C O L O R S  --
--%%%%%%%%%%%%%%%--

local colorscheme = 'ayu'
local is_ok, _ = vim.cmd('colorscheme ' .. colorscheme)
if not is_ok then
    vim.notify('colorscheme `' .. colorscheme .. '` not found!')
    return
end

--%%%%%%%%%%%%%%%--
--  K E Y M A P  --
--%%%%%%%%%%%%%%%--

-- open a (very small) terminal
vim.keymap.set('n', '<leader>t', function()
    vim.cmd 'split | resize 10 | term'
end, {})

-- telescope filesystem (<leader>f...)
local telescope_builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', telescope_builtin.commands, {})
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, {})
vim.keymap.set('n', '<leader>fo', telescope_builtin.vim_options, {})
vim.keymap.set('n', '<leader>fr', telescope_builtin.registers, {})
vim.keymap.set('n', '<leader>ft', telescope_builtin.treesitter, {})

-- telescope git (<leader>g...)
vim.keymap.set('n', '<leader>gb', telescope_builtin.git_branches, {})
vim.keymap.set('n', '<leader>gc', telescope_builtin.git_commits, {})
vim.keymap.set('n', '<leader>gr', telescope_builtin.git_bcommits_range, {})
vim.keymap.set('n', '<leader>gR', telescope_builtin.git_bcommits, {})
vim.keymap.set('n', '<leader>gs', telescope_builtin.git_status, {})
vim.keymap.set('n', '<leader>gS', telescope_builtin.git_stash, {})

-- telescope lsp (g...)
-- NOTE: don't overwrite `ge`, since that's 'go to end of last word'
vim.keymap.set('n', 'gb', telescope_builtin.diagnostics, {})
-- vim.keymap.set('n', 'gc', telescope_builtin.lsp_incoming_calls, {}) -- conflicts with `gcc` for commenting
vim.keymap.set('n', 'gC', telescope_builtin.lsp_outgoing_calls, {})
vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, {})
vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, {})
vim.keymap.set('n', 'gs', telescope_builtin.lsp_document_symbols, {})
vim.keymap.set('n', 'gS', telescope_builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', 'gt', telescope_builtin.lsp_type_definitions, {})
vim.keymap.set('n', 'gw', telescope_builtin.lsp_dynamic_workspace_symbols, {})

-- sniprun
local sniprun = require 'sniprun'
vim.keymap.set('n', '<leader>r', function()
    -- vim.cmd '1,.SnipRun' -- see `:h cmdline-ranges`
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    require('sniprun.api').run_range(1, row)
end)
vim.keymap.set('v', '<leader>r', function()
    sniprun.run 'v'
end)
vim.keymap.set('n', '<leader>R', function()
    vim.cmd '%SnipRun'
end)

--%%%%%%%%%%%%%%%%%--
--  O P T I O N S  --
--%%%%%%%%%%%%%%%%%--

vim.opt.clipboard = 'unnamedplus' -- system clipboard
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' } -- completion?
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.foldenable = false
vim.opt.hlsearch = false
vim.opt.ignorecase = true -- but... (see smartcase)
vim.opt.incsearch = true -- show search results while typing
-- vim.opt.mouse = nil -- disable mouse input
vim.opt.mouse = 'a'
vim.opt.wrap = false
vim.opt.number = true -- line numbers
vim.opt.relativenumber = false
vim.opt.shiftwidth = 4
vim.opt.showmode = true
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true

--%%%%%%%%%%%%%%%%%%%%%%%--
--  C O M P L E T I O N  --
--%%%%%%%%%%%%%%%%%%%%%%%--

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

local luasnip = require 'luasnip'
local cmp = require 'cmp'

cmp.setup {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert {
        -- Use <C-b/f> to scroll the docs
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Use <C-k/j> to switch in items
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        -- Use <CR>(Enter) to confirm selection
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm { select = true },

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
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },

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
    sources = cmp.config.sources {
        { name = 'nvim_lsp' }, -- For nvim-lsp
        { name = 'luasnip' }, -- For luasnip user
        { name = 'buffer' }, -- For buffer word completion
        { name = 'path' }, -- For path completion
    },
}

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--  L A N G U A G E   S E R V E R S  --
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--

-- Set different settings for different languages' LSP
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP
--     - on_attach: a lua callback function to run after LSP attaches to a given buffer
local lspconfig = require 'lspconfig'

-- Customized on_attach function
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, {})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {
        noremap = true,
        -- silent = true,
        buffer = bufnr,
    }
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
    end, bufopts)
    vim.keymap.set('n', '<space>k', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- Covered by Telescope:
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, telescope_builtin.lsp_implementations, bufopts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, telescope_builtin.lsp_references, bufopts)
end

-- LSP binaries:
lspconfig.bashls.setup { on_attach = on_attach }
lspconfig.clangd.setup { on_attach = on_attach }
lspconfig.lua_ls.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = { globals = 'vim' },
            runtime = { version = 'LuaJIT' },
            telemetry = { enable = false },
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        },
    },
}
lspconfig.nil_ls.setup { on_attach = on_attach }
lspconfig.ocamllsp.setup { on_attach = on_attach }
lspconfig.pylsp.setup { on_attach = on_attach }
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    settings = {
        ['rust-analyzer'] = {
            -- <https://rust-analyzer.github.io/manual.html#nvim-lsp>
            cargo = { buildScripts = { enable = true } },
            imports = { granularity = { group = 'module' }, prefix = 'self' },
            inlayHints = { closingBraceHints = true },
            procMacro = { enable = true },
        },
    },
}

--%%%%%%%%%%%%%%%%%%%%%%%--
--  T R E E S I T T E R  --
--%%%%%%%%%%%%%%%%%%%%%%%--

-- <https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim>
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
    group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
    callback = function()
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
})

--%%%%%%%%%%%%%%%%%%%%%%%--
--  A U T O F O R M A T  --
--%%%%%%%%%%%%%%%%%%%%%%%--

vim.api.nvim_create_augroup('AutoFormat', {})

local formatter = function(pattern, command)
    vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = pattern,
        group = 'AutoFormat',
        callback = function()
            vim.cmd('silent !' .. command)
            vim.cmd 'edit'
        end,
    })
end

formatter('*.lua', 'stylua --call-parentheses=None --indent-type=Spaces --quote-style=ForceSingle %')
formatter('*.nix', 'nixfmt %')
formatter('*.py', 'black %')
formatter('*.rs', 'rustfmt %')

--%%%%%%%%%%%%%%%%%--
--  P L U G I N S  --
--%%%%%%%%%%%%%%%%%--

-- Comment.nvim
require('Comment').setup()

-- gitsigns
-- <https://github.com/lewis6991/gitsigns.nvim#installation--usage>
require('gitsigns').setup {
    signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '?' },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },
    yadm = {
        enable = false,
    },
}

-- iron.nvim
-- <https://github.com/Vigemus/iron.nvim#how-to-configure>
require('iron.core').setup {
    config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
            sh = {
                -- Can be a table or a function that
                -- returns a table (see below)
                command = { 'zsh' },
            },
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = require('iron.view').bottom(40),
    },
    -- Iron doesn't set keymaps by default anymore.
    -- You can set them here or manually add keymaps to the functions in iron.core
    keymaps = {
        send_motion = '<space>sc',
        visual_send = '<space>sc',
        send_file = '<space>sf',
        send_line = '<space>sl',
        send_until_cursor = '<space>su',
        send_mark = '<space>sm',
        mark_motion = '<space>mc',
        mark_visual = '<space>mc',
        remove_mark = '<space>md',
        cr = '<space>s<cr>',
        interrupt = '<space>s<space>',
        exit = '<space>sq',
        clear = '<space>cl',
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = {
        italic = true,
    },
    ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- jupytext
-- <https://github.com/GCBallesteros/jupytext.nvim#configuration>
require('jupytext').setup {
    style = 'hydrogen',
    output_extension = 'auto', -- Default extension. Don't change unless you know what you are doing
    force_ft = nil, -- Default filetype. Don't change unless you know what you are doing
    custom_language_formatting = {},
}

-- lualine
-- <https://github.com/nvim-lualine/lualine.nvim#default-configuration>
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
}

-- sniprun
-- <https://michaelb.github.io/sniprun/sources/README.html#configuration>
require('sniprun').setup { display = { 'NvimNotify' } }

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
--%%%%%%%%%%%%%%%--
--  W O O H O O  --
--%%%%%%%%%%%%%%%--

require 'notify' '`init.lua` loaded successfully.'
