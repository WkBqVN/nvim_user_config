return {
  colorscheme = "onedark",
  plugins = {
    {
      "navarasu/onedark.nvim",
      name = "onedark",
      config = function()
        require("onedark").setup({
          style = 'darker',
          transparent = true,
          term_color = true,
          colors = {
            red = '#ff0000'
          },
          highlights = {
            ["@comment"] = { fg = '$red' },
          },
        })
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
          display_callback = function(variable, _buf, _stackframe, _node)
            return variable.name .. ' = ' .. variable.value
          end,

          -- experimental features:
          virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
          all_frames = false,    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false,    -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil
        }
      end,
    },
    {
      "leoluz/nvim-dap-go",
      name = "dap-go",
      config = function()
        require("dap-go").setup()
      end,
    },
    {
      "mfussenegger/nvim-dap-python",
      name = "dap-python",
      config = function()
        local home = os.getenv('HOME')
        require('dap-python').setup(home .. '/.local/share/nvim/mason/packages/debugpy/venv/bin/python')
      end,
    },
    {
      "mfussenegger/nvim-jdtls",
      name = "jdtls"
    },
    {
      "mfussenegger/nvim-dap",
      name = "dap",
      config = function()
        local dap = require("dap")
        local home = os.getenv('HOME')
        dap.set_log_level("trace")
        dap.adapters.coreclr = {
          type = 'executable',
          command = home .. '/.local/share/nvim/mason/packages/netcoredbg/netcoredbg',
          args = { '--interpreter=vscode' }
        }
        dap.configurations.cs = {
          {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
              --return vim.fn.input("File dll to debug: ", vim.fn.getcwd() .. '/bin/Debug/', 'file')
              --return vim.fn.input("File dll to debug: ", vim.fn.getcwd() .. '/bin/Debug/net6.0/' .. '*.dll')
              return vim.fn.input('File(.dll) to debug: ', vim.fn.getcwd() .. '/bin/Debug/net6.0/', 'file')
            end,
          },
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
      config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end
        dapui.setup({
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
          expand_lines = vim.fn.has("nvim-0.7") == 1,
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
          }
        })
      end,
    },
    {
      "fatih/vim-go"
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      cmd = "Neotree",
      init = function() vim.g.neo_tree_remove_legacy_commands = true end,
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
        }
      },
    },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      build = ":Copilot auth",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
      },
      config = function()
        require('copilot').setup {
          anel = {
            enabled = true,
            auto_refresh = true,
            keymap = {
              jump_prev = "[[",
              jump_next = "]]",
              accept = "<CR>",
              refresh = "gr",
              open = "<M-CR>" --alt + enter
            },
            layout = {
              position = "bottom", -- | top | left | right
              ratio = 0.2
            },
          },
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
            keymap = {
              accept = "<M-l>", -- alt + l
              accept_word = false,
              accept_line = false,
              next = "<M-]>",
              prev = "<M-[>",
              dismiss = "<C-]>",
            },
          },
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
          },
          copilot_node_command = 'node', -- Node.js version must be > 16.x
          server_opts_overrides = {},
        }
      end,
    },
  },
}
