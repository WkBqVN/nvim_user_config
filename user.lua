--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:
CMAIN = ""
local f = io.popen "ls *.debug"
if not f then
  print "Failed to init debug files"
  return 0
end
for filename in f:lines() do
  if string.match(filename, "%.debug") then CMAIN = string.sub(filename, 0, -7) .. ".cpp" end
end
f:close()
---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip" (plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs" (plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
          -- don't add a pair if the next character is %
              :with_pair(cond.not_after_regex "%%")
          -- don't add a pair if  the previous character is xxx
              :with_pair(
                cond.not_before_regex("xxx", 3)
              )
          -- don't move right when repeat character
              :with_move(cond.none())
          -- don't delete if the next character is xx
              :with_del(cond.not_after_regex "xx")
          -- disable adding a newline when you press <cr>
              :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)      -- override the options using lazy.nvim
      opts.section.header.val = { -- change the header section value
        [[                                   ]],
        [[                                   ]],
        [[                                   ]],
        [[   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ]],
        [[    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ]],
        [[          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ]],
        [[           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ]],
        [[          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ]],
        [[   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ]],
        [[  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ]],
        [[ ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ]],
        [[ ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ]],
        [[      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ]],
        [[       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ]],
        [[                                   ]],
      }
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    name = "nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup {
        enabled = true,                     -- enable this plugin (the default)
        enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true,            -- show stop reason when stopped for exceptions
        commented = false,                  -- prefix virtual text with comment string
        only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
        all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
        display_callback = function(variable, _buf, _stackframe, _node) return variable.name .. " = " .. variable.value end,

        -- experimental features:
        virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = false,    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false,    -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil,
      }
    end,
  },
  {
    "leoluz/nvim-dap-go",
    name = "dap-go",
    init = function() require("dap-go").setup() end,
  },
  {
    "mfussenegger/nvim-dap-python",
    name = "dap-python",
    config = function()
      local home = os.getenv "HOME"
      require("dap-python").setup(home .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    name = "jdtls",
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local home = os.getenv "HOME"
      dap.set_log_level "trace"
      dap.adapters.coreclr = {
        type = "executable",
        command = home .. "/.local/share/nvim/mason/packages/netcoredbg/netcoredbg",
        args = { "--interpreter=vscode" },
      }
      -- Cshap
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            --return vim.fn.input("File dll to debug: ", vim.fn.getcwd() .. '/bin/Debug/', 'file')
            --return vim.fn.input("File dll to debug: ", vim.fn.getcwd() .. '/bin/Debug/net6.0/' .. '*.dll')
            return vim.fn.input("File(.dll) to debug: ", vim.fn.getcwd() .. "/bin/Debug/net6.0/", "file")
          end,
        },
      }
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "/home/joker/.local/share/nvim/mason/bin/OpenDebugAD7",
      }
      --C++
      dap.configurations.cpp = {
        {
          name = "  Debug file (Recommendation)",
          type = "cppdbg",
          request = "launch",
          program = function()
            if CMAIN == "" then CMAIN = vim.fn.input "Set Main: " end
            vim.fn.system(string.format("clang++ --debug %s -o %s.debug", CMAIN, string.sub(CMAIN, 0, -5)))
            return string.format("%s/%s.debug", vim.fn.getcwd(), string.sub(CMAIN, 0, -5))
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
        },
        {
          name = "Make debug file (Recommendation)",
          -- type = "cppdbg",
          -- request = "launch",
          program = function()
            if CMAIN == "" then CMAIN = vim.fn.input "Set Main: " end
            vim.fn.system(string.format("clang++ --debug %s -o %s.debug", CMAIN, string.sub(CMAIN, 0, -5)))
            -- return string.format("%s/%s.debug",vim.fn.getcwd(),string.sub(CMAIN,0,-5))
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
        },
        {
          name = "Attach to gdbserver :1234",
          type = "cppdbg",
          request = "launch",
          MIMode = "gdb",
          miDebuggerServerAddress = "localhost:1234",
          miDebuggerPath = "/usr/bin/gdb",
          cwd = "${workspaceFolder}",
          program = function()
            return vim.fn.input("Path to executable(with .cpp at end): ", vim.fn.getcwd() .. "/", "file")
          end,
        },
      }
      --java
      dap.configurations.java = {
        {
          classPaths = {},

          -- If using multi-module projects, remove otherwise.
          projectName = "yourProjectName",

          javaExec = "/usr/bin/java",
          mainClass = "",

          -- If using the JDK9+ module system, this needs to be extended
          -- `nvim-jdtls` would automatically populate this property
          modulePaths = {},
          name = "main",
          request = "launch",
          type = "java",
        },
      }
      dap.adapters.java = {
        type = "server",
        host = "127.0.0.1",
        port = 5005,
      }
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "nvim-dap" },
    cmd = { "DapInstall", "DapUninstall" },
    opts = { handlers = {} },
  },
  {
    "rcarriga/nvim-dap-ui",
    name = "dapui",
    opts = { floating = { border = "rounded" } },
    -- init = function() require("dapui").open()
    -- end,
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      dapui.setup {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = vim.fn.has "nvim-0.7" == 1,
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 35, -- 40 columns
            position = "right",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true,
          -- Display controls in this element
          element = "repl",
        },
        floating = {
          max_height = nil,  -- These can be integers or a float between 0 and 1.
          max_width = nil,   -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        },
      }
    end,
  },
  {
    "fatih/vim-go",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "Neotree",
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
      require("neo-tree.sources.manager").show "filesystem"
    end,
    opts = {
      window = {
        position = "right",
      },
      filesystem = {
        filtered_items = {
          visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },
  },
}
