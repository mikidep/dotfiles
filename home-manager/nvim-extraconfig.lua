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

require 'lspconfig'.openscad_lsp.setup {
  cmd = { "@openscad-lsp@", "--stdio" }
}
