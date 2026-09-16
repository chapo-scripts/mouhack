DocGen = {
    PROJECT_PATH = select(1, debug.getinfo(1).source:match("@(.+)\\src\\init%.lua"))
}

function DocGen:MakeFunctionsList()
    print("Generating functions list...")
    local list = {}

    local function formatItem(i, isOption)
        local label = #i.label > 1 and i.label or (i.text or "Unknown")
        return ("%s* %s%s"):format(
            string.rep(" ", isOption and 4 or 2),
            isOption and label or "**" .. label .. "**",
            (i.description and #i.description < 50) and ": " .. i.description or ""
        )
    end
    
    for _, category in ipairs(Categories.list) do
        table.insert(list, "### " .. category.name)
        for _, page in ipairs(category.pages) do
            table.insert(list, "#### " .. page.name)
            for _, func in ipairs(page.funcs) do
                table.insert(list, formatItem(func, false))
                for _, option in ipairs(func.options or {}) do
                    table.insert(list, formatItem(option, true))
                end
            end
        end
    end        
    
    local filePath = self.PROJECT_PATH .. "\\FUNCTIONS.md"
    print("Functions reference was saved to:", filePath)
    local file, err = io.open(filePath, "w")
    assert(file, ("Unable to save FUNCTIONS.md as %s: %s"):format(filePath, err))
    file:write(table.concat(list, "\n"))
    file:close()
end

function DocGen:MakeRequirementsList()
    print("Generating requirements list...")
    local reqs = {}
    for k, v in pairs(package.loaded) do
        if (not k:find("%.")) then
            table.insert(reqs, k)
        end
    end
    table.sort(reqs, function(a, b) return a < b end)
    for k, v in ipairs(reqs) do
        print(k, v)
    end
end