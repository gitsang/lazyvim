-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Config sync functionality
local config_sync = require("utils.config_sync")
vim.api.nvim_create_user_command("SyncConfigToExample", config_sync.sync_config, {})
config_sync.setup_auto_sync() -- Enable automatic sync on save
