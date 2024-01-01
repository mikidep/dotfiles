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
