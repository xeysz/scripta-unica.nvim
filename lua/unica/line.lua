local vim = vim
local Line = {}

function Line:new(text)
    local o = {
        len = 0,
        str = text or "",
    }
    setmetatable(o, self)
    self.__index = self

    o:update_len()

    return o
end

-- Returns the number of columns this line would be displayed as.
-- It's supposed to take into account unicode, tabs, etc...
-- XXX: This function description is terribly vague
local function col_count(str)
    -- XXX: This approach does NOT handle tabs appropriately
    -- #self.str-1 gives us effectively the last byte in the string because lua doesn't parse multibyte
    -- characters
    -- We have to add 1 because charidx index starts at 0
    return vim.fn.charidx(str, #str-1) + 1
end

-- This function sets self.len with the computed number of columns
function Line:update_len()
    self.len = col_count(self.str)
end

-- Removes whitespace from beginning and end of self.str and sets self.str with that value
function Line:trim()
    self.str = self.str:gsub("^%s*(.-)%s*$", "%1")
    self:update_len()
end

function Line:prepend(text)
    self.str = text..self.str
    self:update_len()
end

function Line:append(text)
    self.str = self.str..text
    self:update_len()
end

function Line:pad_left(width, chr)
    local padding_len = width - self.len
    if padding_len >= 0 then
        local padding = string.rep(chr, padding_len)
        self.str = padding..self.str
        self:update_len()
    end
end

function Line:pad_right(width, chr)
    local padding_len = width - self.len
    if padding_len >= 0 then
        local padding = string.rep(chr, padding_len)
        self.str = self.str..padding
        self:update_len()
    end
end

return Line

