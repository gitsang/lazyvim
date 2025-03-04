return {
  "ravitemer/mcphub.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
  },
  -- cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
  build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
  config = function()
    require("mcphub").setup({
      -- Required options
      port = 3000, -- Port for MCP Hub server
      config = vim.fn.expand("~/mcpservers.json"), -- Absolute path to config file

      -- Optional options
      on_ready = function(hub)
        print("MCP Hub is serving at " .. ":" .. hub.port .. " (" .. hub.client_id .. ")")
      end,
      on_error = function(err)
        print("MCP Hub error: " .. err)
      end,
      log = {
        level = vim.log.levels.WARN,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
      },
    })
  end,
}
