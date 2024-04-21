#!/usr/bin/env lua

local function trim(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end

local function get_files(path)
    local cmd = string.format("find '%s' -type f -name '*.unica'", path)
    local fd = assert(io.popen(cmd))
    local files = {}
    for filename in fd:lines() do
        table.insert(files, filename)
    end
    fd:close()
    return files
end

-- Returns list of tags.
-- Takes a file descriptor to a file to be parsed
-- Tags are only searched on the first line of the file
local function get_tags(fd)
    local first_line = fd:read("l")
    local tags = {}
    for tag in first_line:gmatch("#[^%s]+") do
        table.insert(tags, tag)
    end
    return tags
end

local function get_tasks_pending(fd)
    local tasks = {}
    for line in fd:lines() do
        if line:match('^%s*') then
            local v = trim(line)
            table.insert(tasks, v)
        end
    end
    return tasks
end

local function get_tasks_done(fd)
    local tasks = {}
    for line in fd:lines() do
        if line:match('^%s*') then
            local v = trim(line)
            table.insert(tasks, v)
        end
    end
    return tasks
end

local function sort_tags(tags)
    local keys = {}
    for tag, _ in pairs(tags) do
        table.insert(keys, tag)
    end

    table.sort(keys)
    local sorted = {}
    for _, tag in ipairs(keys) do
        local current_tag = tags[tag]
        current_tag.tag = tag
        table.insert(sorted, current_tag)
    end

    return sorted
end

local function new_tag()
    return {
        files = {},
    }
end

local function build_index(path)
    local files = get_files(path)

    local tags = {}
    tags[""] = new_tag()
    for _, filename in pairs(files) do
        local fd = assert(io.open(filename, "r"))

        local file_tags = get_tags(fd)
        if #file_tags == 0 then
            table.insert(file_tags, "")
        end
        fd:seek("set", 0)

        local tasks_pending = get_tasks_pending(fd)
        fd:seek("set", 0)

        local tasks_done = get_tasks_done(fd)
        fd:seek("set", 0)

        for _, tag in pairs(file_tags) do
            if tags[tag] == nil then
                tags[tag] = new_tag()
            end

            local current_tag = tags[tag]

            local file_data = {
                filename = filename,
                tasks_pending = tasks_pending,
                tasks_done = tasks_done,
            }

            table.insert(current_tag.files, file_data)
        end
    end

    local sorted = sort_tags(tags)

    return { tags=sorted }
end

local path = arg[1] or "."
local index = build_index(path)
for _, tag in ipairs(index.tags) do
    if(tag.tag ~= "") then
        print(string.format("%s (%u)", tag.tag, #tag.files))
    else
        print(string.format("(%u)", #tag.files))
    end

    for _, file_data in ipairs(tag.files) do
        local total_tasks = #file_data.tasks_done + #file_data.tasks_pending
        print(string.format("  %q (%u/%u)",
            file_data.filename,
            #file_data.tasks_done,
            total_tasks
        ))

        for _, task in ipairs(file_data.tasks_pending) do
            print("    "..task)
        end

        for _, task in ipairs(file_data.tasks_done) do
            print("    "..task)
        end
    end
end

