local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>cme", function()
  vim.cmd.RustLsp("expandMacro")
end, { buffer = bufnr, desc = "Rust: Expand macro (recursively)" })

vim.keymap.set("n", "<leader>cmr", function()
  vim.cmd.RustLsp("rebuildProcMacros")
end, { buffer = bufnr, desc = "Rust: Rebuild proc-macros" })
