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

      -- Cargo build script settings
      ra.cargo = ra.cargo or {}
      ra.cargo.buildScripts = ra.cargo.buildScripts or {}
      ra.cargo.buildScripts.enable = true
      ra.cargo.loadOutDirsFromCheck = true

      -- Proc macros
      ra.procMacro = ra.procMacro or {}
      ra.procMacro.enable = true

      -- Disable the inactive code warning
      ra.diagnostics = ra.diagnostics or {}
      ra.diagnostics.disabled = { "inactive-code" }

      -- Tell rust-analyzer to enable all crate features
      ra.cargo.allFeatures = true
    end,
  },
}
