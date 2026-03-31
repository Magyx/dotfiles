return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    local show_hidden = os.getenv("SNACKS_SHOW_HIDDEN") == "1"

    -- We merge our custom logic into the existing snacks options
    opts.explorer = opts.explorer or {}
    opts.explorer.hidden = show_hidden

    -- Also apply to the Picker (Fuzzy Finder) if you use it
    opts.picker = opts.picker or {}
    opts.picker.sources = opts.picker.sources or {}
    opts.picker.sources.explorer = {
      hidden = show_hidden,
    }
  end,
}
