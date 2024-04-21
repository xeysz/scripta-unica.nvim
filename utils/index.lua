#!/usr/bin/env lua

local filesfd = assert(io.popen("rg -g '*.unica' --files"))

local tags = {}
for filename in filesfd:lines() do
    local tagsfd = assert(
        io.popen("head -n 1 \""..filename.."\" | rg --only-matching '#[^\\s]+'")
    )
    for tag in tagsfd:lines() do
        if tags[tag] == nil then
            tags[tag] = { filename }
        else
            table.insert(tags[tag], filename)
        end
    end
    tagsfd:close()
end
filesfd:close()

local sorted = {}
for tag in pairs(tags) do
    table.insert(sorted, tag)
end

table.sort(sorted)

for _, tag in pairs(sorted) do
    print(string.format("%s (%u)", tag, #tags[tag]))
    for _, filename in pairs(tags[tag]) do
        print("  "..filename)
    end
end

