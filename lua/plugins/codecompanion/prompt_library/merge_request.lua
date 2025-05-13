local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "workflow",
  description = "Create or update a merge request with auto-generated description",
  opts = {
    index = 6,
    short_name = "mr",
  },
  prompts = {
    {
      -- Initial system setup
      {
        role = constants.SYSTEM_ROLE,
        content = [[
You are a helpful assistant specializing in creating meaningful merge request descriptions based on commit history.
Your task is to organize commits by type and generate a structured MR description.

When analyzing commits:
1. Group commits by type (Feature, Fix, Chore, etc.)
2. Summarize commit content concisely (don't just repeat commit messages)
3. Format the description according to the specified template

Please format the output as:
```
### <Type>

- <commit_id> - <Summarized commit content>
```

Group commits by type and ensure your description is clear and concise.
]],
        opts = { visible = false },
      },
      {
        role = constants.USER_ROLE,
        content = "Please enter the target branch name for your merge request:",
        opts = { auto_submit = false },
      },
    },
    {
      {
        role = constants.USER_ROLE,
        content = function(context)
          -- Get target branch from user input
          local target_branch = context.messages[2].content

          -- Get current branch
          local handle = io.popen("git branch --show-current 2>/dev/null")
          if not handle then
            return "Error getting current branch"
          end
          local current_branch = handle:read("*a"):gsub("%s+$", "") -- Trim whitespace
          handle:close()

          -- Get commit diff
          local cmd = string.format(
            "git -c pager.log=false log --pretty=format:'%%h - %%s' HEAD...origin/%s 2>/dev/null",
            target_branch
          )
          handle = io.popen(cmd)
          if not handle then
            return "Error getting commit diff"
          end
          local commits = handle:read("*a")
          handle:close()

          -- Check if MR exists
          local check_cmd = string.format(
            "glab mr list --source-branch %s --target-branch %s --per-page 1 2>/dev/null",
            current_branch,
            target_branch
          )
          handle = io.popen(check_cmd)
          if not handle then
            return "Error checking existing MRs"
          end
          local mr_result = handle:read("*a")
          handle:close()

          -- Extract MR ID if exists
          local mr_id = nil
          if mr_result and mr_result:match("^!(%d+)") then
            mr_id = mr_result:match("^!(%d+)")
          end

          local mr_status = ""
          if mr_id then
            mr_status = string.format("MR #%s already exists for this branch and will be updated.", mr_id)
          else
            mr_status = "A new MR will be created."
          end

          return string.format(
            [[
I'm generating a merge request from branch %s to origin/%s. %s

Please analyze these commits and create a merge request description by grouping them by type:

```
%s
```

Make sure to:
1. Group commits by type (Feature, Fix, Chore, etc.)
2. Summarize each commit concisely
3. Format using the template:

```
### <Type>

- <commit_id> - <Summarized commit content>
```

Please provide a title for the MR and the formatted description.
]],
            current_branch,
            target_branch,
            mr_status,
            commits
          )
        end,
        opts = { auto_submit = true },
      },
    },
    {
      {
        role = constants.USER_ROLE,
        content = function(context)
          -- Get target branch from first input
          local target_branch = context.messages[2].content

          -- Get LLM response with title and description
          local llm_response = context.messages[3].content

          -- Extract title and description
          local title = llm_response:match("Title: (.-)\n") or "MR from LLM"
          -- Extract everything after the Title line as the description
          local description = llm_response:gsub("^Title: .-\n", "")

          -- Get current branch
          local handle = io.popen("git branch --show-current 2>/dev/null")
          if not handle then
            return "Error getting current branch"
          end
          local current_branch = handle:read("*a"):gsub("%s+$", "") -- Trim whitespace
          handle:close()

          -- Check if MR exists
          local check_cmd = string.format(
            "glab mr list --source-branch %s --target-branch %s --per-page 1 2>/dev/null",
            current_branch,
            target_branch
          )
          handle = io.popen(check_cmd)
          if not handle then
            return "Error checking existing MRs"
          end
          local mr_result = handle:read("*a")
          handle:close()

          -- Extract MR ID if exists
          local mr_id = nil
          if mr_result and mr_result:match("^!(%d+)") then
            mr_id = mr_result:match("^!(%d+)")
          end

          -- Create a temporary file for the description
          local tmp_file = os.tmpname()
          local file = io.open(tmp_file, "w")
          if file then
            file:write(description)
            file:close()
          end

          -- Execute the command to create or update MR
          local command = ""
          if mr_id then
            -- Update existing MR
            command = string.format(
              "glab mr update %s --target-branch %s --title '%s' --description-file '%s'",
              mr_id,
              target_branch,
              title,
              tmp_file
            )
          else
            -- Create new MR
            command = string.format(
              "glab mr create --target-branch %s --title '%s' --description-file '%s'",
              target_branch,
              title,
              tmp_file
            )
          end

          handle = io.popen(command .. " 2>&1")
          local result = ""
          if handle then
            result = handle:read("*a")
            handle:close()
          end

          -- Clean up temp file
          os.remove(tmp_file)

          return string.format(
            [[
Merge request %s:

%s

Title: %s
Target branch: %s

Result:
%s
]],
            mr_id and "updated" or "created",
            description,
            title,
            target_branch,
            result
          )
        end,
        opts = { auto_submit = true },
      },
    },
  },
}

