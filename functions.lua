



function CloneTable(a_Table)
    local copy = {}
    for k, v in pairs(a_Table) do
        if (type(v) == "table") then
            copy[k] = CloneTable(v)
        else
            copy[k] = v
        end
    end
    return copy
end




function MergeSettingsWithIni(a_IniFilePath, a_MergeObject)
    local ini = cIniFile()
    ini:ReadFile(a_IniFilePath)
    local output = CloneTable(a_MergeObject)
    for ic, category in ipairs(output) do
        if (category.IsMultiKeyCategory) then
            -- local numValues = 
        else
            for io, option in ipairs(category.Options) do
                if (option.Type ~= "header") then
                    option.OriginalValue = ini:GetValue(category.CategoryName, option.Name)
                    option.CurrentValue = option.OriginalValue
                end
            end
        end
    end
    return output
end