
-- init.lua

-- Contains the initialization code.





function Initialize(a_Plugin)
	a_Plugin:SetName(g_PluginInfo.Name)
	a_Plugin:SetVersion(g_PluginInfo.Version)

	a_Plugin:AddWebTab("Server Settings", HandleWebRequest)
	
	LOG("Initialized");
	return true;
end

