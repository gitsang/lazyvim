return {
  {
    "golang/tools",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/gotools",
    ft = "go",
    config = function()
      require("plugins.gotools.gotags").setup()
    end,
  },
}
