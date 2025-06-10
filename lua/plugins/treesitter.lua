local function read_scm_file(filepath)
  local file = io.open(filepath, "r")
  if not file then
    return "Could not open file: " .. filepath
  end

  local content = file:read("*a")
  file:close()

  return content
end

local HOME = os.getenv("HOME")

vim.treesitter.query.set(
  "markdown",
  "highlights",
  read_scm_file(HOME .. "/.config/nvim/lua/plugins/treesitter/queries/markdown/highlights.scm")
)

vim.treesitter.query.set(
  "markdown_inline",
  "highlights",
  read_scm_file(HOME .. "/.config/nvim/lua/plugins/treesitter/queries/markdown_inline/highlights.scm")
)

return {}
