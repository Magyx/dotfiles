return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader><space>",
        LazyVim.pick("find_files", { hidden = true, no_ignore = true }),
        desc = "Find Files (Root Dir, incl. ignored)",
      },
      {
        "<leader>ff",
        LazyVim.pick("find_files", { hidden = true, no_ignore = true }),
        desc = "Find Files (Root Dir, incl. ignored)",
      },
      {
        "<leader>fF",
        LazyVim.pick("find_files", { hidden = true, no_ignore = true, root = false }),
        desc = "Find Files (cwd, incl. ignored)",
      },
    },
  },
}
