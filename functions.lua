



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




function FindInTable(a_Table, a_Callback)
    for key, value in pairs(a_Table) do
        if (a_Callback(value, key)) then
            return value, key
        end
    end
end




function MergeSettingsWithIni(a_IniFilePath, a_MergeObject)
    local ini = cIniFile()
    ini:ReadFile(a_IniFilePath)
    local output = CloneTable(a_MergeObject)
    for ic, category in ipairs(output) do
        if (category.IsMultiKeyCategory) then
            -- local numValues = ini:GetNumValues(category.CategoryName);
            -- for i = 0, numValues - 1 do
            --     local name = ini:GetValueName(category.CategoryName, i)
            --     local option;
            --     if (name == category.RequiredKey) then
            --         -- option = FindInTable(category.Options, function(a_Option) return a_Option.Name == category.RequiredKey end)
            --         -- Assume the first option is the required key
            --         option = category.Options[1]
            --     else
            --         option = category.Options[2 + i]
            --     end
            --     option.OriginalValue = ini:GetValue(category.CategoryName, i)
            --     option.CurrentValue = option.OriginalValue
            -- end
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



--- Returns a list of all the keys in the provided object.
function Keys(a_Obj)
	local outp = {}
	for key, _ in pairs(a_Obj) do
		table.insert(outp, key);
	end
	return outp
end



--- Creates a copy of the provided table and 
-- adds the additional provided parameter at the end
-- This function was created because {unpack(t), arg} doesn't work
function pack(a_Table, a_NewArg)
	local copy = {unpack(a_Table)}
	table.insert(copy, a_NewArg)
	return copy;
end





function CreateCondition(a_CategoryName, a_OptionName, a_Method, a_ExpectedValue)
    return
    {
        Target =
        {
            CategoryName = a_CategoryName,
            OptionName = a_OptionName,
        },
        Method = a_Method,
        ExpectedValue = a_ExpectedValue
    }
end



