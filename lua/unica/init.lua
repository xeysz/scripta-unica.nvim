local vim = vim
local Line = require('unica.line')

local M = {}
local settings = {}

function M.setup(user_settings)
    -- TODO: should override settings with user_settings instead of completely assigning
    settings = user_settings
end

function M.insert_div()
    local textwidth = vim.api.nvim_buf_get_option(0, 'textwidth')

    local equals_line = string.rep("─", textwidth)
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, {equals_line})
end

function M.align_left(start_line, end_line)
    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    for i, str in ipairs(lines) do
        local line = Line:new(str)
        line:trim()
        lines[i] = line.str
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, lines)
end

function M.align_right(start_line, end_line)
    local width = vim.bo.textwidth

    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    for i, str in ipairs(lines) do
        local line = Line:new(str)
        line:trim()
        line:pad_left(width, " ")
        lines[i] = line.str
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, lines)
end

function M.align_center(start_line, end_line)
    local width = vim.bo.textwidth
    local padding_char = " "

    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    for i, str in ipairs(lines) do
        line = Line:new(str)
        line:trim()
        if line.len < width then
            local pad = width - line.len
            local left_pad = math.floor(pad/2)
            local right_pad = pad - left_pad
            lines[i] = string.rep(padding_char, left_pad) ..
                line.str ..
                string.rep(padding_char, right_pad)
        end
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, lines)
end

function M.toggle_h1(start_line, end_line, align)
    local pad_chr = "█"
    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, start_line, false)
    local str = lines[1]
    if string.match(str, "^" .. pad_chr) then
        M.remove_h1(start_line, end_line)
    else
        M.insert_h1(start_line, end_line, align)
    end
end

function M.insert_h1(start_line, end_line, align)
    local prepend_text = "█"
    local append_text = "█"
    local pad_chr = "█"
    local width = vim.bo.textwidth
    local space_padding = 1

    local vimlines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    local lines = {}
    local title_width = 0

    for i, str in ipairs(vimlines) do
        local line = Line:new(str)
        line:trim()
        if line.len > title_width then
            title_width = line.len
        end
        lines[i] = line
    end

    for i = 1, #lines do
        local line = lines[i]

        local left_spaces = string.rep(" ",space_padding)
        local right_spaces = string.rep(" ", title_width + space_padding - line.len)

        line:prepend(prepend_text .. left_spaces)
        line:append(right_spaces .. append_text)
        line:pad_left(line.len+2, pad_chr)
        line:pad_right(width, pad_chr)
        vimlines[i] = line.str
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, vimlines)
end

function M.remove_h1(start_line, end_line)
    local prepend_text = "█"
    local append_text = "█"
    local pad_chr = "█"

    local vimlines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)

    for i, str in ipairs(vimlines) do
        str = str:gsub("^[" .. pad_chr .. "]*", "")
        str = str:gsub("^".. prepend_text, "")
        str = str:gsub(append_text .. "[" .. pad_chr .. "]*$", "")
        local line = Line:new(str)
        line:trim()
        vimlines[i] = line.str
    end

    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, vimlines)
end

function M.toggle_h2(start_line, end_line, align)
    local pad_chr = "━"
    local outline_text = "┃"
    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, start_line, false)
    local str = lines[1]
    if str:match("^" .. pad_chr) or str:match("^%s*" .. outline_text) then
        M.remove_h2(start_line, end_line)
    else
        M.insert_h2(start_line, end_line, align)
    end
end

function M.insert_h2(start_line, end_line, align)
    local prepend_text = "┫"
    local append_text = "┣"
    local pad_chr = "━"
    local outline_text = "┃"
    local width = vim.bo.textwidth
    local space_padding = 1

    local vimlines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    local lines = {}
    local title_width = 0

    for i, str in ipairs(vimlines) do
        local line = Line:new(str)
        line:trim()
        if line.len > title_width then
            title_width = line.len
        end
        lines[i] = line
    end

    for i = 1, #lines do
        local line = lines[i]

        local left_spaces = string.rep(" ",space_padding)
        local right_spaces = string.rep(" ", title_width + space_padding - line.len)

        if i < 2 then
            line:prepend(prepend_text .. left_spaces)
            line:append(right_spaces .. append_text)
            line:pad_left(line.len+2, pad_chr)
            line:pad_right(width, pad_chr)
        else
            line:prepend(outline_text .. left_spaces)
            line:append(right_spaces .. outline_text)
            line:pad_left(line.len+2, " ")
            line:pad_right(width, " ")
        end
        vimlines[i] = line.str
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, vimlines)
end

function M.remove_h2(start_line, end_line)
    local prepend_text = "┫"
    local append_text = "┣"
    local outline_text = "┃"
    local pad_chr = "━"

    local vimlines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)

    for i, str in ipairs(vimlines) do
        str = str:gsub("^[" .. pad_chr .. "]*" .. prepend_text, "")
        str = str:gsub(append_text .. "[" .. pad_chr .. "]*$", "")
        str = str:gsub("^%s*" .. outline_text, "")
        str = str:gsub(outline_text .. "%s*$", "")
        local line = Line:new(str)
        line:trim()
        vimlines[i] = line.str
    end

    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, vimlines)
end

-- XXX: This is a very simple probe. If the first character matches, then we assume it is currently
-- a valid h3 and proceed to attempt to remove it from the rest of the lines. Otherwise we insert_h3
function M.toggle_h3(start_line, end_line, align)
    local prepend_text = "⌘ "
    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, start_line, false)
    local str = lines[1]
    if string.match(str, "^" .. prepend_text) then
        M.remove_h3(start_line, end_line)
    else
        M.insert_h3(start_line, end_line, align)
    end
end

function M.insert_h3(start_line, end_line, align)
    local prepend_text = "⌘ "
    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    for i, str in ipairs(lines) do
        local line = Line:new(str)
        line:trim()
        lines[i] = prepend_text..line.str
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, lines)
end

function M.remove_h3(start_line, end_line)
    local prepend_text = "⌘ "
    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    for i, str in ipairs(lines) do
        str = str:gsub("^"..prepend_text, "")
        local line = Line:new(str)
        line:trim()
        lines[i] = line.str
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, lines)
end

return M

