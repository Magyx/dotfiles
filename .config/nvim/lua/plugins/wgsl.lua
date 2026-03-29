-- lua/plugins/wgsl.lua
return {
  -- Treesitter: WGSL is upstream, just ensure it's installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "wgsl" })
        -- optional: Bevy extras
        -- vim.list_extend(opts.ensure_installed, { "wgsl_bevy" })
      end
    end,
  },

  -- Filetype detection (covers older setups)
  {
    "folke/lazy.nvim",
    init = function()
      vim.filetype.add({ extension = { wgsl = "wgsl" } })
    end,
  },

  -- LSP via Mason + lspconfig
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "wgsl-analyzer" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        wgsl_analyzer = {
          settings = { ["wgsl-analyzer"] = { inlayHints = { enabled = true } } },
        },
      },
    },
  },
}
