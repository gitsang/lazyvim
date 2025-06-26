return {
  {
    "local/commandline",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/commandline",
    config = function()
      require("plugins.commandline.git").setup()
    end,
  },
}
