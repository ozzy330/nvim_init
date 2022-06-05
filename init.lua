-- LazyLoad some time:
--https://elianiva.my.id/post/improving-nvim-startup-time#prerequisite


-- Plugins
packer = require 'packer'
-- Change default options for packer
-- packer.init {}

local use = packer.use
packer.reset() -- Recommended

packer.startup({ function()
  use 'wbthomason/packer.nvim' -- Plugint manager packer

  use { 'neovim/nvim-lspconfig' } -- Collection of configurations for the built-in LSP client
  use { 'williamboman/nvim-lsp-installer' } -- Insaller of LSP servers
  use { 'hrsh7th/nvim-cmp' } -- Autocompletion plugin
  use { 'hrsh7th/cmp-nvim-lsp' } -- LSP source for nvim-cmp
  use { 'hrsh7th/cmp-nvim-lua' } -- Nvim-cmp source for neovim Lua API.
  use { 'hrsh7th/cmp-buffer' } -- Nvim-cmp source for buffer words.
  use { 'hrsh7th/cmp-path' } -- Nvim-cmp source for path
  use { 'hrsh7th/cmp-cmdline' } -- Nvim-cmp source for vim's cmdline

  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  use { 'sainnhe/gruvbox-material' } -- Theme
  use { 'rmehri01/onenord.nvim' }

  use 'nvim-lua/plenary.nvim' -- Complementary library of lua functions for some plugins
  -- Telescope
  -- Suggested / Optional dependencies
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'kyazdani42/nvim-web-devicons' }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
  }
  use { "nvim-telescope/telescope-file-browser.nvim" } -- manage files
  use { "nvim-telescope/telescope-dap.nvim" } -- easy acces to debugger things

  -- For better syntax highlight
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }

  -- For auto nohls afert some move
  use {"romainl/vim-cool"}

  -- To move faster on screen
  use {'ggandor/lightspeed.nvim'}

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }

  -- Tabs manager
  use {
    'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  -- PopUp Terminal
  use { "akinsho/toggleterm.nvim" }

  -- Git integrations
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end,
  }
  use { 'tpope/vim-fugitive' }

  -- Manage comments
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  }
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        signs = false,
        highlight = {
          keyword = "bg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
          pattern = [[.*(KEYWORDS)(\([^\)]*\))?:]],
          -- Match:
          -- Every keyword
          -- Character (
          -- Every previous character except )
          -- Character )
          -- Only one :
        },
        search = {
          pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
        },
      }
    end,
  }

  -- Extra
  use { 'max397574/better-escape.nvim' }
  use { 'karb94/neoscroll.nvim' }
  use { 'andymass/vim-matchup' }

  -- Debbugger
  use { 'mfussenegger/nvim-dap' }
  use { "Pocco81/DAPInstall.nvim" }
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }

end,
-- Make packer use a floating window for outputs
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
} })

require('neoscroll').setup()
require("better_escape").setup {
  mapping = { "jk" }, -- a table with mappings to use
  timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
  clear_empty_lines = false, -- clear line after escaping if there is only whitespace
  keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
  -- example(recommended)
  -- keys = function()
  --   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
  -- end,
}
require 'nvim-treesitter.configs'.setup {
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = { "c", "ruby" }, -- optional, list of language that will be disabled
    -- [options]
  },
}
-- NVIM LSP
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>FO', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {}
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- LSP servers
local lsp_installer = require("nvim-lsp-installer")
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities
  }
  -- NOTE: tal vez agregar aquí el compilador
  -- This setup() function will take the provided server configuration and decorate it with the necessary properties
  -- before passing it onwards to lspconfig.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)

-- Nvim-cmp && LuaSnip configuration
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require 'cmp'

cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),

    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

    -- Super-Tab like mapping
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  -- Order is a ranking of priority
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 4 }, -- Show only after 4 leters pressed
    { name = 'cmdline' },
  },

  experimental = {
    native_menu = false;
    ghost_text = true;
  }
}

-- Debbugger configuration
-- local status_ok, dapui = pcall(require, 'dapui')
-- if not status_ok then
--   return
-- end
--
-- local dap = require('dap')
local dap, dapui = require("dap"), require("dapui")
dapui.setup()

-- Open the UI when start debugging
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
-- Exit the UI when stop debugging
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.adapters.lldb = {
  type = 'executable',
  -- absolute path is important here, otherwise the argument in the `runInTerminal` request will default to $CWD/lldb-vscode
  command = '/usr/bin/lldb-vscode-14',
  name = "lldb"
}
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {},
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    runInTerminal = false,
  },
  {
    name = "Launch_args",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    -- ASk for arguments
    args = function()
      local argument_string = vim.fn.input('Program arguments: ')
      return vim.fn.split(argument_string, " ", true)
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    runInTerminal = false,
  },
}
-- Used for C and C++
dap.configurations.c = dap.configurations.cpp

-- Telescope configuration
local actions = require("telescope.actions")
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["jk"] = actions.close
      },
    },
  },
}

require("telescope").load_extension "file_browser"
require('telescope').load_extension('dap')

-- Lualine configuration
require('lualine').setup()

-- PopUp terminal
require('toggleterm').setup {}

-- Git integrations

-- colors configuration
vim.cmd [[colorscheme onenord]]
require 'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
}
require('lualine').setup {
  options = {
    theme = 'onenord'
  }
}

-- inactive statuslines as thin lines
-- vim.cmd("hi StatusLineNC guifg=Red gui=underline")

-- General configuration

-- set like variable
local set = vim.opt

set.termguicolors = true -- more colors

set.expandtab = true -- spaces instead of tab
set.shiftwidth = 2 -- spaces for (auto)indent
set.softtabstop = 2 -- number of spaces fot tabs

set.wrap = false -- avoid wrapping lines

set.splitbelow = true -- new split below of current
set.splitright = true -- new split rigth of current
set.laststatus = 3 -- Global status line

set.number = false -- remove numbers for lines

set.signcolumn = "yes:1"
set.cursorline = false

-- toggle realtive numbers on the active window
vim.cmd [[
  augroup numbertoggle
    autocmd!
    autocmd bufenter,focusgained,insertleave,winenter * if &nu && mode() != "i" | set rnu   | endif
    autocmd bufleave,focuslost,insertenter,winleave   * if &nu                  | set nornu | endif
  augroup end
]]
vim.g.mapleader = " "

-- keybindings

-- easy keymapping
local keymap = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

keymap('i', 'jk', '<esc>', { noremap = true }) -- exit insert mode
keymap('i', '<c-h>', '<c-w>', { noremap = true }) -- delete previous word (h = bs)

-- manage splits
keymap('n', '<C-s>l', ':vsp<cr>', options) -- create vertical split
keymap('n', '<C-s>j', ':sp<cr>', options) -- create horizontal split
keymap('n', '_', '5<c-w><', { noremap = true }) -- increase split height
keymap('n', '+', '5<c-w>>', { noremap = true }) -- increase split width
keymap('n', '=', '<c-w>=', { noremap = true }) -- normalize all split sizes
keymap('n', '<m-_>', '5<c-w>-', { noremap = true }) -- increase split height
keymap('n', '<m-=>', '5<c-w>+', { noremap = true }) -- increase split width
keymap('n', '<C-s>x', ':only<cr>', options) -- close all but current split
keymap('n', '<c-j>', '<c-w><c-j>', { noremap = true }) -- move to split below
keymap('n', '<c-k>', '<c-w><c-k>', { noremap = true }) -- move to split above
keymap('n', '<c-l>', '<c-w><c-l>', { noremap = true }) -- move to split on the right
keymap('n', '<c-h>', '<c-w><c-h>', { noremap = true }) -- move to split on the left

-- manage buffers
keymap('n', '<s-l>', ':BufferNext<CR>', options) -- go to next buffer
keymap('n', '<s-h>', ':BufferPrevious<CR>', options) -- go to previous buffer
keymap('n', '<space><S-x>', ':BufferClose<CR>', options) -- close buffer without messing with splits
keymap('n', '<space><S-o>', ':BufferCloseAllButCurrent<CR>', options) -- close all buffers except current

-- manage tabs
keymap('n', 'tn', ':tabnew<CR>', options) -- create tab
keymap('n', '<tab>', ':tabnext<CR>', options) -- move to next tab
keymap('n', '<s-tab>', ':tabprevious<CR>', options) -- move to previous tab
keymap('n', '<space>tx', ':tabclose<CR>', options) -- close current tab
keymap('n', '<space>to', ':tabonly<CR>', options) -- close all tabs except current

-- telescope keybindings
keymap('n', '<leader>ff', '<cmd>Telescope find_files theme=dropdown<CR>', options) -- Find files
keymap('n', '<leader>fb', '<cmd>Telescope buffers theme=dropdown<CR>', options) -- Find buffer
keymap('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols theme=dropdown<CR>', options) -- Find code symbols
keymap('n', '<leader>fr', '<cmd>Telescope lsp_references theme=dropdown<CR>', options) -- Find referens of hover word
keymap('n', '<leader>fe', '<cmd>Telescope diagnostics theme=dropdown<CR>', options) -- Find errors in code
keymap('n', '<leader>fa', '<cmd>Telescope lsp_code_actions theme=dropdown<CR>', options) -- Find quick fixes for erros
-- load_extensions
keymap('n', '<leader>FF', '<cmd>Telescope file_browser theme=dropdown<CR>', options) -- Browse folders and files
keymap('n', '<leader>fn', '<cmd>TodoTelescope theme=dropdown<CR>', options) -- Find especial comments
keymap('n', '<leader>DD', '<cmd>Telescope dap list_breakpoints theme=dropdown<CR>', options) -- Find especial comments

-- PopUp terminal configuration
keymap('n', 'tt', ':ToggleTerm direction=float<CR>', options) -- Toogle terminal
keymap('n', 'tvt', ':ToggleTerm direction=vertical<CR>', options) -- Toogle terminal
keymap('n', 'tht', ':ToggleTerm direction=horizontal<CR>', options) -- Toogle terminal
keymap('n', '<leader>tt', ':ToggleTerm direction=tab<CR>', options) -- Toogle terminal
keymap('t', '<ESC>', '<C-\\><C-N>:ToggleTerm<CR>', options) -- Easily exit popup terminal

-- Manage debbuger
keymap('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>", options) -- Add Breakpoint to line
-- Add conditional breakpoint to line
keymap('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", options)
keymap('n', '<leader>x', ":lua require'dap'.clear_breakpoints()<CR>", options) -- Clear all breakpoints
keymap('n', '<leader>dc', ":lua require'dap'.continue()<CR>", options) -- Start debbuging
keymap('n', '<leader>ds', ":lua require'dap'.step_over()<CR>", options) -- Step over on debugger
keymap('n', '<leader>di', ":lua require'dap'.step_into()<CR>", options) -- Step into on debugger
keymap('n', '<leader>do', ":lua require'dap'.step_out()<CR>", options) -- Step out on debugger
keymap('n', '<leader>dh', ":lua require'dap'.run_to_cursor()<CR>", options) -- Go to here (cursor)
keymap('n', '<leader>dx', ":lua require'dap'.terminate()<CR>", options) -- Stop debbuging
keymap('n', '<leader>dd', ":lua require('dapui').toggle()<CR>", options) -- Toggle debug UI

-- Manage Git
keymap('n', '<leader>gs', ":G<CR>", options) -- Toggle status of repository
keymap('n', '<leader>gv', ":Gvsplit<CR>", options) -- Show vertical split without changes
keymap('n', '<leader>gl', ":diffget //2", options) -- Get left
keymap('n', '<leader>gk', ":diffget //2", options) -- Get right
