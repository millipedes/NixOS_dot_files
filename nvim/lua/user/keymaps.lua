local opts = { noremap = true, silent = true }
local loud_opts = {noremap = true, silent = false }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap , as leader key
keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c"

-- Normal --
-- Better window navigation
keymap("n", "<C-A-Left>", "<C-w>h", opts)
keymap("n", "<C-A-Right>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<A-Up>", ":resize -2<CR>", opts)
keymap("n", "<A-Down>", ":resize +2<CR>", opts)
keymap("n", "<A-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<A-Right>", ":vertical resize +2<CR>", opts)

-- Open all tabs
keymap("n", "<leader>o", "<Esc>:tab all<CR>", opts)

-- tab prev/next
keymap("n", "<leader>a", "<Esc>:tabprevious<CR>", opts)
keymap("n", "<leader>s", "<Esc>:tabnext<CR>", opts)
keymap("n", "<C-PageUp>", "<Esc>:tabprevious<CR>", opts)
keymap("n", "<C-PageDown>", "<Esc>:tabnext<CR>", opts)
keymap("n", "<leader>w", "<ESC>:tabClose<CR>", opts)

-- Spellcheck on/off
keymap("n", "<leader>c", "<Esc>:set spell spelllang=en_us<CR>", opts)
keymap("n", "<leader>n", "<Esc>:set nospell<CR>", opts)

-- Quickly get into vsplit
keymap("n", "<leader>v", "<Esc>:vsplit ", loud_opts)

-- Quickly get into vsplit
keymap("n", "<leader>m", "<Esc>:w<CR><Esc>:make<CR><CR>", opts)

keymap("n", ",e", "<Esc>:Lex 20<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<C-Down>", ":m .+1<CR>==", opts)
keymap("v", "<C-Up>", ":m .-2<CR>==", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "<C-Down>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<C-Up>", ":move '<-2<CR>gv-gv", opts)

