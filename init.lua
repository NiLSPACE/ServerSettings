
-- init.lua

-- Contains the initialization code.





function Initialize(a_Plugin)
	a_Plugin:SetName(g_PluginInfo.Name)
	a_Plugin:SetVersion(g_PluginInfo.Version)

	InitEndpointsServer()
	InitEndpointsWorld()
	
	a_Plugin:AddWebTab("Server Settings", HandleWebRequest_Server)
	a_Plugin:AddWebTab("World Settings", HandleWebRequest_World)
	
	LOG("Initialized");
	return true;
end

