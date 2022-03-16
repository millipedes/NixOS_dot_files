local options = {
    backup = false,                          -- creates a backup file
    smartcase = true,			             -- Smartcase
    clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    fileencoding = "utf-8",                  -- the encoding written to a file
    hlsearch = false,                        -- highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    mouse = "a",                             -- allow the mouse to be used in neovim
    --termguicolors = true,
    pumheight = 10,                          -- pop up menu height
    smartindent = true,                      -- make indenting smarter again
    splitbelow = true,                       -- force all horizontal splits to go below current window
    splitright = true,                       -- force all vertical splits to go to the right of current window
    swapfile = false,                        -- creates a swapfile
    timeoutlen = 1000,                       -- time to wait for a mapped sequence to complete (in milliseconds)
    updatetime = 300,                        -- faster completion (4000ms default)
    writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,                        -- convert tabs to spaces
    shiftwidth = 2,                          -- the number of spaces inserted for each indentation
    tabstop = 2,                             -- insert 4 spaces for a tab
    cursorline = false,                      -- highlight the current line
    number = true,                           -- set numbered lines
    relativenumber = true,                   -- set relative numbered lines
    numberwidth = 4,                         -- set number column width to 4
    wrap = true,                             -- display lines as one long line
    textwidth=80,
    colorcolumn = "80",                   -- line at 80 chars
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]       -- This makes multple-words 1 word w/rt vim
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
