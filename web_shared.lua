




function HandleEndpointRestartServer(a_Request)
	cRoot:Get():QueueExecuteConsoleCommand("restart")
	return [["Restarting"]], "application/json"
end




function HandleEndpointPing(a_Request)
	return [["Pong"]], "application/json"
end






function HandleEndpointApplyChanges(a_Request)
	local changes = a_Request.PostParams["changes"];
	if (not changes) then
		return [["No changes provided"]];
	end
	local decoded = cJson:Parse(changes)
	if (not decoded) then
		return [["Changes are not valid JSON"]], "text/plain";
	end

	local targets = {}
	local function GetIniFile(a_Target)
		-- No target provided = settings.ini.
		-- We can't use nil as index so use the targets table itself as a workaround.
		a_Target = a_Target or targets;
		if (targets[a_Target]) then
			return targets[a_Target].ini
		end
		local path;
		if (a_Target == targets) then
			path = "settings.ini"
		else
			path = cRoot:Get():GetWorld(a_Target):GetIniFileName()
		end
		local ini = cIniFile();
		ini:ReadFile(path)
		targets[a_Target] = {ini = ini, path = path}
		return ini
	end

	for idx, change in ipairs(decoded) do
		local ini = GetIniFile(change.target)
		local category = FindInTable(change.target == nil and g_ServerSettingsOptions or g_WorldSettings, function(category) return category.CategoryName == change.category end)
		if (category.IsMultiKeyCategory) then
			if (category.RequiredKey == change.option) then
				ini:SetValue(change.category, change.option, change.value)
			else
				local key, index = change.option:match("(%w+)%&(.+)")
				if (index == "NEW") then
					ini:AddValue(change.category, key, change.value)
				else
                    if (change.value == "") then
                        ini:DeleteValueByID(ini:FindKey(change.category), tonumber(index))
                    else
					    ini:SetValue(ini:FindKey(change.category), tonumber(index), change.value)
                    end
				end
			end
		else
			ini:SetValue(change.category, change.option, change.value)
		end
	end

	for _, iniPath in pairs(targets) do
		iniPath.ini:WriteFile(iniPath.path)
	end
	return [["OK"]], "text/plain"
end



