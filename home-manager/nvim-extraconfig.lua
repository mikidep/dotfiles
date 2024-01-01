local lspconfig = require("lspconfig")

lspconfig.nil_ls.setup {
  autostart = true,
  cmd = { "nil" },
  settings = {
    ['nil'] = {
      formatting = {
        command = { "${pkgs.alejandra}/bin/alejandra" },
      },
    },
  },
}
