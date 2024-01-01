local lspconfig = require("lspconfig")

lspconfig.nil_ls.setup {
  autostart = true,
  cmd = { "@nil@" },
  settings = {
    ['nil'] = {
      formatting = {
        command = { "@alejandra@" },
      },
    },
  },
}

lspconfig.lua_ls.setup {
  cmd = { "@lua-language-server@" },
}


require("nvfs-keymaps")

local Hydra = require("hydra")
local tsis = require("nvim-treesitter.incremental_selection")
Hydra({
  name = "Treesitter",
  body = "<leader>s",
  mode = { "n", "x" },
  heads = {
    { "i", tsis.init_selection,   { mode = "n" } },
    { "j", tsis.node_decremental, { mode = "x" } },
    { "k", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), 'x', true)
      tsis.node_incremental()
    end, { mode = "x" } }
  }
})
