local colorscheme = "PaperColor" --May not be spelled right!! -- for rtjblue/gold
--local colorscheme = "256_noir" -- for PantherlikeaPanther
--local colorscheme = "gruvbox"

vim.cmd("set t_Co=256")

-- If colorscheme not installed let user know and don't crash
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

-- No terminal background
vim.cmd [[au Colorscheme * hi Normal ctermbg=NONE guibg=NONE]]
vim.cmd [[au Colorscheme * hi Nontext ctermbg=NONE guibg=NONE]]
vim.cmd [[au Colorscheme * hi clear LineNr]]
