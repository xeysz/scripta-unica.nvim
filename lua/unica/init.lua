local vim = vim
local Line = require('unica.line')

local M = {}

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

function M.insert_h1(start_line, end_line, align)
    local prepend_text = "█ "
    local append_text = " █"
    local pad_text = "█"
    local width = vim.bo.textwidth

    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    for i, str in ipairs(lines) do
        local line = Line:new(str)
        line:trim()
        --line = trim(line)
        line:prepend(prepend_text)
        line:append(append_text)
        --line.str = prepend_text..line..append_text
        --local len = vim.fn.charidx(line, #line-1) + 1
        --local right_pad = width - len
        --lines[i] = line..string.rep(pad_text, right_pad)
        lines[i] = line.str
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, lines)
end

function M.insert_h2(start_line, end_line, align)
end

function M.insert_h3(start_line, end_line, align)
    local prepend_text = "⌘ "
    local lines = vim.api.nvim_buf_get_lines(0, start_line-1, end_line, false)
    for i, line in ipairs(lines) do
        line = trim(line)
        lines[i] = prepend_text..line
    end
    vim.api.nvim_buf_set_lines(0, start_line-1, end_line, false, lines)
end

return M

