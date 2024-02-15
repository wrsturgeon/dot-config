local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  }),
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = "path" },
    },
    { { name = 'buffer' } }
  )
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources(
    { { name = 'git' } }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    { { name = 'buffer' } }
  )
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = 'path' } },
    { { name = 'cmdline' } }
  )
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, buf)
  -- Example maps, set your own with vim.api.nvim_buf_set_keymap(buf, "n", <lhs>, <rhs>, { desc = <desc> })
  -- or a plugin like which-key.nvim
  -- <lhs>        <rhs>                        <desc>
  -- "K"          vim.lsp.buf.hover            "Hover Info"
  -- "<leader>qf" vim.diagnostic.setqflist     "Quickfix Diagnostics"
  -- "[d"         vim.diagnostic.goto_prev     "Previous Diagnostic"
  -- "]d"         vim.diagnostic.goto_next     "Next Diagnostic"
  -- "<leader>e"  vim.diagnostic.open_float    "Explain Diagnostic"
  -- "<leader>ca" vim.lsp.buf.code_action      "Code Action"
  -- "<leader>cr" vim.lsp.buf.rename           "Rename Symbol"
  -- "<leader>fs" vim.lsp.buf.document_symbol  "Document Symbols"
  -- "<leader>fS" vim.lsp.buf.workspace_symbol "Workspace Symbols"
  -- "<leader>gq" vim.lsp.buf.formatting_sync  "Format File"
  vim.api.nvim_buf_set_keymap(buf, 'n', '<leader>k', vim.lsp.buf.hover, { desc = "Hover info" })

  vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
  vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

require('rust-tools').setup({ server = { capabilities = capabilities, on_attach = lsp_attach } })

local snip = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if snip.expand_or_jumpable() then
    snip.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if snip.jumpable(-1) then
    snip.jump(-1)
  end
end, { silent = true })

vim.keymap.set("i", "<C-l>", function()
  if snip.choice_active() then
    snip.change_choice(1)
  end
end)
