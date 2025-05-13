local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

-- Function to execute a command and return its output
local function execute_command(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

-- Function to get current branch name
local function get_current_branch()
  local result = execute_command("git rev-parse --abbrev-ref HEAD")
  return result:gsub("%s+$", "") -- Trim whitespace
end

-- Function to get commit differences between current branch and target branch
local function get_commit_diff(target_branch)
  local command = string.format(
    "git -c pager.log=false log origin/%s..HEAD --pretty=format:\"%%h - %%s [%%an]\"",
    target_branch
  )
  return execute_command(command)
end

-- Function to categorize commits by type
local function categorize_commits(commit_diff)
  local categories = {
    Feature = {},
    Fix = {},
    Chore = {},
    Refactor = {},
    Docs = {},
    Test = {},
    Other = {},
  }
  
  for commit in commit_diff:gmatch("[^\r\n]+") do
    -- Try to determine the type from commit message
    local commit_id = commit:match("^(%w+)")
    local commit_msg = commit:match("%w+ %- (.+)$") or ""
    
    local category = "Other"
    local lower_msg = commit_msg:lower()
    
    if lower_msg:match("feat") or lower_msg:match("add") or lower_msg:match("new") then
      category = "Feature"
    elseif lower_msg:match("fix") or lower_msg:match("bug") or lower_msg:match("issue") then
      category = "Fix"
    elseif lower_msg:match("chore") or lower_msg:match("maintain") then
      category = "Chore"
    elseif lower_msg:match("refactor") then
      category = "Refactor"
    elseif lower_msg:match("doc") then
      category = "Docs"
    elseif lower_msg:match("test") then
      category = "Test"
    end
    
    -- Summarize the commit message
    local summary = commit_msg
    if #summary > 100 then
      summary = summary:sub(1, 97) .. "..."
    end
    
    table.insert(categories[category], {
      id = commit_id,
      summary = summary
    })
  end
  
  return categories
end

-- Function to generate MR description from categorized commits
local function generate_mr_description(categories)
  local description = ""
  
  for category, commits in pairs(categories) do
    if #commits > 0 then
      description = description .. "### " .. category .. "\n\n"
      
      for _, commit in ipairs(commits) do
        description = description .. "- " .. commit.id .. " - " .. commit.summary .. "\n"
      end
      
      description = description .. "\n"
    end
  end
  
  return description
end

-- Function to check if MR exists
local function check_mr_exists(target_branch)
  local current_branch = get_current_branch()
  local command = string.format(
    "glab mr list --source-branch %s --target-branch %s -L 1 --json iid",
    current_branch,
    target_branch
  )
  
  local output = execute_command(command)
  -- Parse the JSON output to get MR ID if it exists
  local mr_id = output:match('"iid":(%d+)')
  
  return mr_id
end

-- Function to create a new MR
local function create_mr(target_branch, title, description)
  local temp_file = os.tmpname()
  local file = io.open(temp_file, "w")
  file:write(description)
  file:close()
  
  local command = string.format(
    "glab mr create --target-branch %s --title \"%s\" --description \"$(cat %s)\"",
    target_branch,
    title,
    temp_file
  )
  
  local result = execute_command(command)
  os.remove(temp_file)
  
  return result
end

-- Function to update an existing MR
local function update_mr(mr_id, target_branch, title, description)
  local temp_file = os.tmpname()
  local file = io.open(temp_file, "w")
  file:write(description)
  file:close()
  
  local command = string.format(
    "glab mr update %s --target-branch %s --title \"%s\" --description \"$(cat %s)\"",
    mr_id,
    target_branch,
    title,
    temp_file
  )
  
  local result = execute_command(command)
  os.remove(temp_file)
  
  return result
end

-- Main function to create or update MR
local function create_or_update_mr(target_branch)
  -- Get current branch name for title
  local current_branch = get_current_branch()
  local title = "Merge " .. current_branch .. " into " .. target_branch
  
  -- Get commit differences and generate description
  local commit_diff = get_commit_diff(target_branch)
  local categories = categorize_commits(commit_diff)
  local description = generate_mr_description(categories)
  
  -- Check if MR already exists
  local mr_id = check_mr_exists(target_branch)
  
  local result
  if mr_id then
    print("Updating existing MR #" .. mr_id)
    result = update_mr(mr_id, target_branch, title, description)
  else
    print("Creating new MR")
    result = create_mr(target_branch, title, description)
  end
  
  print(result)
  return result
end

return {
  strategy = "chat",
  description = "Create or update GitLab merge request",
  opts = {
    is_slash_cmd = false,
    modes = { "n" },
    short_name = "mr",
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
  },
  prompts = {
    {
      role = constants.SYSTEM_ROLE,
      content = [[
You are a merge request helper. When prompted, you should help create or update merge requests on GitLab.
The user will provide the target branch name, and you'll help create a well-formatted merge request with
properly categorized commits.
]],
      opts = {
        visible = false,
      },
    },
    {
      role = constants.USER_ROLE,
      content = function(_)
        -- Prompt user for target branch
        vim.ui.input({ 
          prompt = "Enter target branch name: ", 
        }, function(target_branch)
          if target_branch and target_branch ~= "" then
            create_or_update_mr(target_branch)
          else
            print("No target branch provided, operation cancelled.")
          end
        end)
        
        return "Creating merge request, please wait..."
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
