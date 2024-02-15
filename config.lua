lvim.colorscheme = "oxocharcoal"

lvim.plugins = {
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = {     -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "navarasu/onedark.nvim",
    style = "darker"
  },
  {
    "tpope/vim-surround",
  },
  {
    "nvim-telescope/telescope-fzy-native.nvim",
    build = "make",
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end
  },
  {
    "mg979/vim-visual-multi",
  },
  {
    "casonadams/simple-diagnostics.nvim",
    config = function()
      require("simple-diagnostics").setup({
        virtual_text = false,
        message_area = true,
        signs = true,
      })
    end,
  },
  {
    "rktjmp/hotpot.nvim",
    config = function()
      require("hotpot").setup()
    end
  },
  {
    "F4LCn/oxocharcoal.nvim",
    lazy = lvim.colorscheme ~= "oxocharcoal",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  }
}

lvim.keys.normal_mode[";"] = ":"
lvim.keys.insert_mode["<C-c>"] = "<esc>"


lvim.builtin.telescope.defaults = {
  mappings = {
    i = {
      ["<C-c>"] = false,
    }
  },
  path_display = { 'smart' },
  prompt_prefix = "   ",
  selection_caret = "  ",
  entry_prefix = "  ",
  initial_mode = "insert",
  selection_strategy = "reset",
  sorting_strategy = "ascending",
  layout_strategy = "horizontal",
  layout_config = {
    horizontal = {
      prompt_position = "top",
      preview_width = 0.55,
      results_width = 0.8,
    },
    vertical = {
      mirror = false,
    },
    width = 0.87,
    height = 0.80,
    preview_cutoff = 120,
  },
}

lvim.builtin.telescope.extensions.fzy_native = {
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true,    -- override the file sorter
}

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "fzy_native")
end

local ts = lvim.builtin.treesitter
ts.textobjects = {
  select = {
    enable = true,
    lookahead = true,
    keymaps = {
      ["ia"] = "@parameter.inner",
      ["aa"] = "@parameter.outer",
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      ["ib"] = "@block.inner",
      ["ob"] = "@block.outer",
    },
  },
}
ts.highlight = {
  enable = true,
  additional_vim_regex_highlighting = false,
}
ts.incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = '<C-space>',
    node_incremental = '<C-space>',
    node_decremental = '<C-W>',
  },
}


vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.termguicolors = true


-- which-key custom mappings
lvim.builtin.which_key.mappings = {
  ["w"] = { "<cmd>w!<CR>", "Save" },
  f = {
    name = "Find",
    t = { "<cmd>Telescope live_grep<cr>", "Text" },
    F = { "<cmd>Telescope find_files<cr>", "Find File (All)" },
    l = { "<cmd>Telescope resume<cr>", "Resume last search" },
    m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    f = {
      function()
        require("lvim.core.telescope.custom-finders").find_project_files { previewer = false }
      end,
      "Find File (project)",
    },
    g = { "<cmd>Telescope find_files<cr>", "Git Files" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
  },
  c = {
    name = "Code",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    f = { "<cmd>lua require('lvim.lsp.utils').format()<cr>", "Format" },
    q = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    S = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    s = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
    D = { "<cmd>Telescope diagnostics<cr>", "Workspace diagnostics" },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
  },
  g = {
    name = "Git",
    g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
    b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    B = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    C = {
      "<cmd>Telescope git_bcommits<cr>",
      "Checkout commit(for current file)",
    },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Git Diff",
    },
  },
  t = {
    name = "Trouble",
    t = { "<cmd>TroubleToggle<cr>", "trouble" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
    l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
    r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
  },
  d = {
    name = "Debug",
    b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
    C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
    p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
    s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
    q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    d = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
  },
  b = {
    name = "Buffer",
    j = { "<cmd>BufferLinePick<cr>", "Jump" },
    f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
    x = { "<cmd>BufferKill<CR>", "Close Buffer" },
  },
  N = {
    name = "Nvim",
    c = {
      "<cmd>edit " .. get_config_dir() .. "/config.lua<cr>",
      "Edit config.lua",
    },
    C = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
  },
  P = {
    name = "PLugin",
    l = { "<cmd>Lazy<cr>", "Lazy" },
    m = { "<cmd>Mason<cr>", "Mason" },
  },
  e = {
    name = "Explorer",
    e = { "<cmd>NvimTreeToggle<CR>", "Toggle Explorer" },
    f = { "<cmd>NvimTreeFocus<CR>", "Focus Explorer" },
  },
  ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
}

lvim.builtin.which_key.vmappings = {
  ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
}

lvim.keys.normal_mode["<Tab>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<F5>"] = "<cmd>lua require'dap'.continue()<cr>"
lvim.keys.normal_mode["<F9>"] = "<cmd>lua require'dap'.step_back()<cr>"
lvim.keys.normal_mode["<F10>"] = "<cmd>lua require'dap'.step_over()<cr>"
lvim.keys.normal_mode["<F11>"] = "<cmd>lua require'dap'.step_into()<cr>"
lvim.keys.normal_mode["<F12>"] = "<cmd>lua require'dap'.step_out()<cr>"

lvim.keys.normal_mode["<Esc>"] = "<cmd> noh <CR>"

-- debug adapters
lvim.builtin.dap.active = true
local dap = require("dap")
dap.adapters = {}
dap.configurations = {}

dap.adapters.coreclr = {
  type = 'executable',
  command = '/usr/share/netcoredbg/netcoredbg',
  args = { '--interpreter=vscode' }
}
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}
dap.adapters.codelldb = {
  type = 'server',
  host = '127.0.0.1',
  port = 13000,
  executable = {
    -- CHANGE THIS to your path!
    command = 'codelldb',
    args = { "--port", "13000" },
    detached = false,
  }
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
dap.configurations.c = {
  {
    name = "Launch - codelldb",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c
dap.configurations["rs"] = dap.configurations.c
