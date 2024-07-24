



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



