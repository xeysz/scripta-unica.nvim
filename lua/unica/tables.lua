local function trim(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end

local function pad_row(row, column_sizes, column_padding)
    local formatted = ""
    for col,cell in ipairs(row) do
        local padding =
            string.rep(" ", column_sizes[col] - #cell + column_padding)
        formatted = formatted..cell..padding
    end
    return formatted
end

local function format_csv(csv_data)
    -- Split the CSV data into lines
    local lines = {}
    for line in csv_data:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local column_sizes = {}

    -- Split the header line into individual headers
    local headers = {}
    for header in lines[1]:gmatch("[^,%s]+") do
        table.insert(headers, header)
        table.insert(column_sizes, #header)
    end

    -- split lines and get max column size for global padding
    local rows = {}
    for i = 2, #lines do
        local row = {}
        local col = 1
        for value in lines[i]:gmatch("[^,]+") do
            local cell = trim(value)
            table.insert(row, cell)
            if column_sizes[col] < #cell then
                column_sizes[col] = #cell
            end

            col = col + 1
        end
        table.insert(rows, row)
    end

    local COL_PADDING = 4

    local formatted_table = {}

    -- header formatting
    local formatted_headers = pad_row(headers, column_sizes, COL_PADDING)
    table.insert(formatted_table, formatted_headers)

    for _,row in ipairs(rows) do
        local formatted = pad_row(row, column_sizes, COL_PADDING)
        table.insert(formatted_table, formatted)
    end

    return table.concat(formatted_table, "\n")
end

-- Example CSV data
local csv_data = [[
header1, header2, header3, header4, header5
aasdf, b, c, d, e
a, b, c, d, e
a, b, c, d, e
]]

-- Format the CSV data
local formattedCsv = format_csv(csv_data)

-- Print the formatted CSV data
print(formattedCsv)

