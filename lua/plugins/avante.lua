local secret = require("vars.secret")

return {
  {
    "gitsang/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      provider = "worklink",
      auto_suggestions_provider = "worklink",
      cursor_applying_provider = nil,
      vendors = {
        ["worklink"] = {
          __inherited_from = "openai",
          endpoint = "https://worklink.yealink.com/llmproxy",
          model = "claude-3.7-sonnet",
          parse_api_key = function()
            return secret.worklink_llm
          end,
        },
      },
      dual_boost = {
        enabled = false,
        first_provider = "openai",
        second_provider = "claude",
        prompt = "根据以下两个参考输出，生成一个结合两者元素但反映您自己判断和独特视角的响应。不要提供任何解释，只需直接给出响应。参考输出 1: [{{provider1_output}}], 参考输出 2: [{{provider2_output}}]",
        timeout = 60000, -- 超时时间（毫秒）
      },
      behaviour = {
        auto_suggestions = false, -- 实验阶段
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true, -- 是否在应用代码块时删除未更改的行
        enable_token_counting = true, -- 是否启用令牌计数。默认为 true。
        enable_cursor_planning_mode = false, -- 是否启用 Cursor 规划模式。默认为 false。
        enable_claude_text_editor_tool_mode = false, -- 是否启用 Claude 文本编辑器工具模式。
      },
      rag_service = {
        enabled = false, -- 启用 RAG 服务
        host_mount = os.getenv("HOME"), -- RAG 服务的主机挂载路径
        provider = "openai", -- 用于 RAG 服务的提供者（例如 openai 或 ollama）
        llm_model = "", -- 用于 RAG 服务的 LLM 模型
        embed_model = "", -- 用于 RAG 服务的嵌入模型
        endpoint = "https://api.openai.com/v1", -- RAG 服务的 API 端点
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        cancel = {
          normal = { "<C-c>", "<Esc>", "q" },
          insert = { "<C-c>" },
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          retry_user_request = "r",
          edit_user_request = "e",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
          remove_file = "d",
          add_file = "@",
          close = { "<Esc>", "q" },
          close_from_input = nil, -- 例如，{ normal = "<Esc>", insert = "<C-d>" }
        },
      },
      hints = { enabled = true },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- 侧边栏的位置
        wrap = true, -- 类似于 vim.o.wrap
        width = 30, -- 默认基于可用宽度的百分比
        sidebar_header = {
          enabled = true, -- true, false 启用/禁用标题
          align = "center", -- left, center, right 用于标题
          rounded = true,
        },
        input = {
          prefix = "> ",
          height = 8, -- 垂直布局中输入窗口的高度
        },
        edit = {
          border = "rounded",
          start_insert = true, -- 打开编辑窗口时开始插入模式
        },
        ask = {
          floating = false, -- 在浮动窗口中打开 'AvanteAsk' 提示
          start_insert = true, -- 打开询问窗口时开始插入模式
          border = "rounded",
          ---@type "ours" | "theirs"
          focus_on_apply = "ours", -- 应用后聚焦的差异
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
        --- 覆盖悬停在差异上时的 'timeoutlen' 设置（请参阅 :help timeoutlen）。
        --- 有助于避免进入以 `c` 开头的差异映射的操作员挂起模式。
        --- 通过设置为 -1 禁用。
        override_timeoutlen = 500,
      },
      suggestion = {
        debounce = 600,
        throttle = 600,
      },
    },
  },
}
