return {
  {
    "local/commandline",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/commandline",
    config = function()
      require("plugins.commandline.git_commit").setup()
      require("plugins.commandline.git_diff").setup()
      require("plugins.commandline.format").setup()
      require("plugins.commandline.yaml_format").setup()
    end,
  },
}
