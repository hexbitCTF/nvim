vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
-- Pressing 'Space + e' will open/close the file explorer
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- Start Live Server in the background with <leader>ls
vim.keymap.set('n', '<leader>ls', function()
    vim.fn.jobstart('live-server --port=5500', { detach = true })
    print("Live Server started on port 5500...")
end, { desc = "Start Live Server" })

-- Auto-correct spelling with <leader>s.
-- Select a sentence and hit Space + s to fix every misspelled word with the
-- top suggestion from nvim's built-in spell engine (undo with u). With no
-- selection, the current line is corrected instead.
local function fix_one_word(word)
    local bad = vim.fn.spellbadword(word)
    if bad[2] ~= "bad" then
        return nil
    end
    local suggestions = vim.fn.spellsuggest(word, 3)
    if #suggestions > 0 and suggestions[1] ~= word then
        return suggestions[1]
    end
    return nil
end

-- Correct misspelled words inside byte range [rs, re] (1-based, inclusive)
-- of a single line. Words that continue outside the range are left alone so a
-- selection can never mangle a half-selected word. Returns the corrected text
-- for that span plus how many words were fixed.
local function is_word_char(ch)
    return ch and ch:match("[%w']") ~= nil
end

local function fix_line_range(line, rs, re)
    if re < rs then
        return nil, 0
    end
    local middle = line:sub(rs, re)

    local parts = {}
    local last = 1
    local pos = 1
    local fixed = 0

    while true do
        local b, e = middle:find("[%a][%w']*", pos)
        if not b then
            break
        end
        local starts_before = b == 1 and is_word_char(line:sub(rs - 1, rs - 1))
        local ends_after = e == #middle and is_word_char(line:sub(rs + e, rs + e))
        if not starts_before and not ends_after then
            local replacement = fix_one_word(middle:sub(b, e))
            if replacement then
                parts[#parts + 1] = middle:sub(last, b - 1)
                parts[#parts + 1] = replacement
                last = e + 1
                fixed = fixed + 1
            end
        end
        pos = e + 1
    end

    if fixed == 0 then
        return nil, 0
    end
    parts[#parts + 1] = middle:sub(last)
    return table.concat(parts), fixed
end

local function autocorrect_selection()
    local start_row, start_col
    local end_row, end_col
    if vim.fn.getpos("'<")[2] == 0 then
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local len = #vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
        start_row, start_col = row, 1
        end_row, end_col = row, math.max(len, 1)
    else
        start_row, start_col = vim.fn.getpos("'<")[2], vim.fn.getpos("'<")[3]
        end_row, end_col = vim.fn.getpos("'>")[2], vim.fn.getpos("'>")[3]
    end
    if #vim.opt_local.spelllang:get() == 0 then
        vim.opt_local.spelllang = "en"
    end

    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    local total = #lines
    local result = {}
    local count = 0

    for i, line in ipairs(lines) do
        local rs, re = 1, #line
        if total == 1 then
            rs, re = start_col, end_col
        else
            if i == 1 then
                rs = start_col
            end
            if i == total then
                re = end_col
            end
        end
        rs = math.max(rs, 1)
        re = math.min(re, #line)

        local fixed, n = fix_line_range(line, rs, re)
        result[i] = fixed or line:sub(rs, re)
        count = count + n
    end

    if count == 0 then
        vim.notify("No misspelled words found", vim.log.levels.INFO)
        return
    end

    vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, result)
    vim.notify(("%d word(s) corrected"):format(count), vim.log.levels.INFO)
end

vim.keymap.set("v", "<leader>s", autocorrect_selection, { desc = "Auto-correct spelling in selection" })
vim.keymap.set("n", "<leader>s", autocorrect_selection, { desc = "Auto-correct spelling in selection/current line" })








