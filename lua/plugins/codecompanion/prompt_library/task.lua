local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

-- Simple logging function
local function log(message)
  print("[TASK WORKFLOW] " .. message)
end

return {
  strategy = "workflow",
  description = "Create a workflow for completing specific tasks step by step",
  opts = {
    index = 5,
    is_default = false,
    short_name = "task",
  },
  prompts = {
    {
      -- Initial setup with system instructions and task description
      {
        role = constants.SYSTEM_ROLE,
        content = function(context)
          return string.format(
            [[ 
            You are a helpful assistant specializing in completing tasks in %s. 
            Break down complex tasks into manageable steps, and work through them methodically. 
            Think step by step and be thorough in your approach. Focus on practical, actionable solutions.

            When you have completed the assigned task, clearly indicate completion by including `[TASK COMPLETE]` phrases on its own line at the end of your message.
            This helps me recognize when we can move to the next stage.
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
        content = "Is the task complete? If not, please continue.",
        opts = {
          auto_submit = true,
        },
        repeat_until = function(chat)
          -- Keep repeating until the LLM indicates the task is complete
          -- by checking if the last message contains phrases indicating completion
          local messages = chat.messages
          if #messages >= 1 then
            local last_message = messages[#messages]
            -- Check if the last LLM message indicates completion
            if last_message.role == constants.LLM_ROLE then
              local completion_indicator = "[TASK COMPLETE]"
              if last_message.content:lower():find(completion_indicator) then
                -- Log when task completion is detected
                log("Task completed successfully! Completion indicator detected.")
                return true -- Found an indicator of completion
              end
            end
          end
          return false -- No indication of completion yet
        end,
      },
    },
    -- Final confirmation
    {
      {
        name = "Final Summary",
        role = constants.USER_ROLE,
        content = "Great! Please provide a summary of what was accomplished and any next steps I should take.",
        opts = {
          auto_submit = true,
        },
      },
    },
  },
}
