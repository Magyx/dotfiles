return {
  -- Extend LazyVim's built-in yamlls setup.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              -- Register the orbit config schema directly.
              -- This runs alongside SchemaStore, not instead of it.
              schemas = {
                ["http://127.0.0.1:7837/schema.json"] = {
                  "**/orbit/config.yaml",
                  "**/orbit/config.yml",
                },
              },
            },
          },
        },
      },
    },
  },
}
