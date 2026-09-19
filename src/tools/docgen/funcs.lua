local FuncDocGenerator = {
    path = PROJECT_PATH .. "\\api\\docs\\FUNCTIONS.md"
}

function FuncDocGenerator:Generate()
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
    
    local filePath = self.path
    print("Functions reference was saved to:", filePath)
    local file, err = io.open(filePath, "w")
    assert(file, ("Unable to save FUNCTIONS.md as %s: %s"):format(filePath, err))
    file:write(table.concat(list, "\n"))
    file:close()
end

return FuncDocGenerator