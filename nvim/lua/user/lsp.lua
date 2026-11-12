-- rust-analyzer through Neovim's built-in LSP client (Neovim 0.11+, no plugin needed).
-- Install the server with: rustup component add rust-analyzer
--
-- In a .rs buffer once it attaches:
--   K           type and docs of the name under the cursor (instead of a C man page)
--   ,th         toggle inline type hints (handy to switch off when practising for an online editor)
--   L           (normal mode) list what can come next after the cursor, e.g. the methods after `v.`
--                 Up / Down   move through the list
--                 Enter       show what the highlighted entry does; the docs then follow Up / Down
--                 Enter       again on the same entry: insert it
--                 Esc         close the list and the docs, back to normal mode
--               In other files L keeps its usual meaning (cursor to the bottom line of the window).
--   grr / grn   references / rename;  gra code actions;  [d ]d  previous / next diagnostic
-- Everywhere else K still opens the man page (:Man) as before.

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
    },
  },
})
vim.lsp.enable("rust_analyzer")

-- The docs window beside the completion list. Enter opens it; it then follows the selection
-- until the list closes.
local docs = { win = nil, shown_for = nil, follow = false }

local function close_docs()
  local win = docs.win
  docs.win, docs.shown_for = nil, nil
  if win and vim.api.nvim_win_is_valid(win) then
    -- Not allowed while a key mapping or autocmd is running; then close it right after.
    if not pcall(vim.api.nvim_win_close, win, true) then
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end)
    end
  end
end

-- Where the docs fit without covering the list: under it, or above the cursor if that has
-- more room.
local function docs_area()
  local pum = vim.fn.pum_getpos()
  if vim.tbl_isempty(pum) then
    return nil
  end
  local last = vim.o.lines - vim.o.cmdheight - 2 -- last screen row above the status line
  local cur = vim.fn.screenrow() - 1
  local list_top, list_end = pum.row, pum.row + pum.height
  local below_top, above_end
  if list_top > cur then
    below_top, above_end = list_end, cur
  else
    below_top, above_end = cur + 1, list_top
  end
  local below_h = last - below_top + 1 - 2 -- 2 rows of border
  local above_h = above_end - 2
  local width = math.min(86, vim.o.columns - 4)
  local col = math.max(0, math.min(pum.col, vim.o.columns - width - 2))
  if below_h >= above_h or below_h >= 8 then
    return { row = below_top, col = col, width = width, height = below_h }
  end
  return { end_row = above_end, col = col, width = width, height = above_h }
end

local function render_docs(lines)
  local area = docs_area()
  if not area or area.height < 2 then
    return false
  end
  close_docs()
  local _, win = vim.lsp.util.open_floating_preview(lines, "markdown", {
    border = "rounded",
    max_width = area.width,
    max_height = area.height,
    focusable = false,
    close_events = {}, -- closed by the autocmds below
  })
  local h, w = vim.api.nvim_win_get_height(win), vim.api.nvim_win_get_width(win)
  local row = area.row or (area.end_row - h - 2)
  vim.api.nvim_win_set_config(win, { relative = "editor", row = row, col = area.col, width = w, height = h })
  docs.win = win
  return true
end

local function show_docs(bufnr, tries)
  tries = tries or 0
  if vim.fn.pumvisible() == 0 then
    return close_docs()
  end
  local info = vim.fn.complete_info({ "selected", "items" })
  if info.selected < 0 then -- the first entry is still being selected
    if tries < 10 then
      vim.defer_fn(function()
        show_docs(bufnr, tries + 1)
      end, 20)
    end
    return
  end
  local sel = info.selected
  local entry = info.items[sel + 1]
  local lsp = vim.tbl_get(entry, "user_data", "nvim", "lsp") or {}
  local item = lsp.completion_item
  local client = lsp.client_id and vim.lsp.get_client_by_id(lsp.client_id)
  local function draw(res)
    -- the list may have closed, or moved on, while rust-analyzer was answering
    if vim.fn.pumvisible() == 0 or vim.fn.complete_info({ "selected" }).selected ~= sel then
      return
    end
    local lines = {}
    if res and res.detail and res.detail ~= "" then
      vim.list_extend(lines, { "```rust", res.detail, "```" })
    end
    if res and res.documentation then
      local md = vim.lsp.util.convert_input_to_markdown_lines(res.documentation)
      if #md > 0 then
        if #lines > 0 then
          table.insert(lines, "")
        end
        vim.list_extend(lines, md)
      end
    end
    if #lines == 0 then
      lines = { (entry.abbr ~= "" and entry.abbr or entry.word) .. ": no documentation" }
    end
    if render_docs(lines) then
      docs.shown_for = sel
    end
  end
  if item and client and client:supports_method("completionItem/resolve") then
    client:request("completionItem/resolve", item, function(err, res)
      vim.schedule(function()
        draw(not err and res or item)
      end)
    end, bufnr)
  else
    draw(item)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "rust_analyzer" then
      return
    end
    local buf = args.buf
    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, { buffer = buf, desc = "Rust: type and docs under cursor" })
    vim.keymap.set("n", "<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
    end, { buffer = buf, desc = "Rust: toggle inline type hints" })

    -- L: start typing after the cursor with rust-analyzer's list open (a list only exists in
    -- insert mode, so Esc closes it and returns to normal mode). Neovim's own LSP completion
    -- builds the list (no popup while typing: autotrigger off) because only it inserts an entry
    -- properly, e.g. `join(sep)` with the cursor on `sep`, not the label `join(…)`.
    vim.lsp.completion.enable(true, client.id, buf, { autotrigger = false })
    vim.keymap.set("n", "L", "a<Cmd>lua vim.lsp.completion.get()<CR>", {
      buffer = buf,
      desc = "Rust: list what can come next",
    })
    vim.keymap.set("i", "<CR>", function()
      if vim.fn.pumvisible() == 0 then
        return "<CR>"
      end
      local sel = vim.fn.complete_info({ "selected" }).selected
      if sel >= 0 and docs.win and docs.shown_for == sel then
        docs.follow = false
        vim.schedule(close_docs)
        return "<C-y>" -- Enter again on the same entry: insert it
      end
      docs.follow = true
      vim.schedule(function()
        show_docs(buf)
      end)
      return sel < 0 and "<Down>" or "" -- nothing highlighted yet: take the first entry
    end, { buffer = buf, expr = true, desc = "Rust: docs for the highlighted entry; again to insert it" })

    local group = vim.api.nvim_create_augroup("user_rust_docs_" .. buf, { clear = true })
    vim.api.nvim_create_autocmd("CompleteChanged", {
      group = group,
      buffer = buf,
      callback = function()
        if docs.follow then
          vim.schedule(function()
            show_docs(buf)
          end)
        end
      end,
    })
    vim.api.nvim_create_autocmd({ "CompleteDone", "InsertLeave" }, {
      group = group,
      buffer = buf,
      callback = function()
        docs.follow = false
        vim.schedule(close_docs)
      end,
    })
  end,
})
