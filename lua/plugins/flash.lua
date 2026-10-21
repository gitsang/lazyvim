return {
  -- Pin flash.nvim to the last commit before the Neovim 0.13 search-state
  -- refactor (#496 / 7eff7f8). That commit switched to the new `SearchState Search`
  -- global, which does not exist in the installed dev build
  -- (v0.13.0-dev-492, `has("nvim-0.13")` == 1 but no `Search` symbol),
  -- causing: "nvim: undefined symbol: Search" on every redraw.
  -- Remove this pin after upgrading Neovim to a build that has `SearchState Search`.
  {
    "folke/flash.nvim",
    commit = "b634694",
  },
}
