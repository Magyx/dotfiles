return {
  {
    "mrcjkb/rustaceanvim",
    version = "*",
    ft = { "rust" },
    opts = function(_, opts)
      opts.server = opts.server or {}
      opts.server.default_settings = opts.server.default_settings or {}
      opts.server.default_settings["rust-analyzer"] = opts.server.default_settings["rust-analyzer"] or {}

      local ra = opts.server.default_settings["rust-analyzer"]
      ra.cargo = ra.cargo or {}
      ra.cargo.buildScripts = ra.cargo.buildScripts or {}

      -- These are the important bits for OUT_DIR + generated include! files
      ra.cargo.buildScripts.enable = true
      ra.cargo.loadOutDirsFromCheck = true

      ra.procMacro = ra.procMacro or {}
      ra.procMacro.enable = true
    end,
  },
}
