local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

return {
  strategy = "workflow",
  description = "Create a workflow for completing specific tasks step by step",
  opts = {
    index = 5,
    is_slash_cmd = true,
    is_default = true,
    short_name = "task",
  },
  prompts = {
    {
      -- Initial setup with system instructions and task description
      {
        role = constants.SYSTEM_ROLE,
        content = function(context)
          -- Leverage auto_tool_mode which disables the requirement of approvals and automatically saves any edited buffer
          vim.g.codecompanion_auto_tool_mode = true

          -- Some clear instructions for the LLM to follow
          return string.format(
            [[ 
You are a helpful assistant specializing in completing tasks in lua. 
Break down complex tasks into manageable steps, and work through them methodically. 
Think step by step and be thorough in your approach. Focus on practical, actionable solutions.

When approaching a task:
1. First analyze the requirements and constraints
2. Outline a clear plan before implementation
3. Explain your reasoning at key decision points
4. Provide status updates as you progress
5. Test your solution thoroughly when appropriate

If you encounter obstacles or need clarification:
- Clearly state what information you need
- Explain why this information is necessary
- Suggest possible alternatives if available

IMPORTANT - DIAGNOSTIC CHECK PROCEDURE:
Before marking any task as complete, you MUST perform the following diagnostic checks:
1. Check for syntax errors in any code you've written or modified
2. Verify that variable names are consistent throughout the code
3. Ensure proper formatting and indentation
4. Confirm that all functions and methods referenced actually exist
5. Review logic for potential edge cases or bugs
6. Verify that any dependencies or imports are properly handled
7. Check for performance issues in critical sections
8. Ensure error handling is implemented where necessary

COMPLETION PROTOCOL:
Only when ALL of these diagnostic checks pass, indicate completion by including 
`[TASK COMPLETE]` phrase on its own line at the end of your message.

If ANY diagnostics fail, clearly indicate:
- What specific issues were found
- Suggested fixes for each issue
- DO NOT mark the task as complete until these are resolved

IMPORTANT: ONLY use the `[TASK COMPLETE]` marker when the ENTIRE task has been successfully completed
AND all diagnostic checks have passed. NEVER include this marker in intermediate responses or when
only part of the task has been done or when diagnostics have detected issues.
If you need more information or the task is still ongoing, DO NOT include the completion marker.
            ]],
            context.filetype
          )
        end,
        opts = {
          visible = false,
        },
      },
      {
        role = constants.USER_ROLE,
        content = "@full_stack_dev I need you to complete the following task: ",
        opts = {
          auto_submit = false,
        },
      },
    },
    -- Repeat until completion
    {
      {
        name = "Task Complete Check",
        role = constants.USER_ROLE,
        content = "Continue.",
        opts = {
          auto_submit = true,
        },
        repeat_until = function(chat)
          -- Keep repeating until the LLM indicates the task is complete
          -- by checking if the last message contains phrases indicating completion
          local completion_indicator = "[TASK COMPLETE]"
          local messages = chat.messages
          if #messages >= 1 then
            local last_message = messages[#messages]
            -- Check if the last LLM message indicates completion
            if last_message.role == constants.LLM_ROLE then
              -- Split the content string into lines
              local lines = {}
              for line in last_message.content:gmatch("[^\r\n]+") do
                table.insert(lines, line)
              end
              -- Check each line for the completion indicator
              for _, line in ipairs(lines) do
                if line:find(completion_indicator, 1, true) then
                  return true -- Found an indicator of completion
                end
              end
            end
          end
          return false -- No indication of completion yet
        end,
      },
    },
  },
}
