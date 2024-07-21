









--- Builds a file path from all parameters using cFile:GetPathSeparator as the separator.
-- Expects that all arguments are strings.
local function CreatePath(...)
	return table.concat({...}, cFile:GetPathSeparator())
end





function LinkEndpoints(a_Content)
	return a_Content
	:gsub('src="main.js"', 'src="?endpoint=file&file=main.js"')
	:gsub('src="polyfills.js"', 'src="?endpoint=file&file=polyfills.js"')
	:gsub('href="styles.css"', 'href="?endpoint=file&file=styles.css"')
	:gsub('src="main%-(%w-)%.js"', 'src="?endpoint=file&file=main-%1.js"')
	:gsub('src="polyfills%-(%w-)%.js"', 'src="?endpoint=file&file=polyfills-%1.js"')
	:gsub('href="styles%-(%w-)%.css"', 'href="?endpoint=file&file=styles-%1.css"')
end





--- All the files that the web page can request.
local g_Files = {
	index =  {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "index.html"), mime = "text/html", finalizer=LinkEndpoints},
	["polyfills%-(%w+)%.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "polyfills-%1.js"), mime = "application/javascript" },
	["main%-(%w+)%.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "main-%1.js"), mime = "application/javascript" },
	["styles%-(%w+)%.css"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "styles-%1.css"), mime = "text/css" },
	["polyfills.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "polyfills.js"), mime = "application/javascript" },
	["main.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "main.js"), mime = "application/javascript" },
	["styles.css"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "styles.css"), mime = "text/css" },
}





--- Endpoint that handles the loading/returning of the index page, it's javascript/css files and it's libraries
function HandleEndpointGetFile(a_Request)
	local fileReq = a_Request.Params["file"]
	for filePattern, fileInfo in pairs(g_Files) do
		local match = fileReq:match(filePattern)
		if (match) then
			local path = fileReq:gsub(filePattern, fileInfo.path)
			local content = cFile:ReadWholeFile(path)
			if (fileInfo.finalizer) then
				content = fileInfo.finalizer(content)
			end
			return content, fileInfo.mime
		end
	end
	return "Unknown file"
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
		ini:SetValue(change.category, change.option, change.value)
	end

	for _, iniPath in pairs(targets) do
		iniPath.ini:WriteFile(iniPath.path)
	end
	return [["OK"]], "text/plain"
end




function HandleEndpointRestartServer(a_Request)
	cRoot:Get():QueueExecuteConsoleCommand("restart")
	return [["Restarting"]], "application/json"
end




function HandleEndpointPing(a_Request)
	return [["Pong"]], "application/json"
end





function HandleEndpointGetWorlds(a_Request)
	local worlds = GetWorldSettings()
	return cJson:Serialize(worlds), "application/json"
end





function HandleEndpointServerSettings(a_Request)
	local settings = MergeSettingsWithIni("settings.ini", g_ServerSettingsOptions)
	return cJson:Serialize(settings), "application/json"
end





function HandleEndpointPossibleServerSettings(a_Request)
	return cJson:Serialize(g_ServerSettingsOptions), "application/json"
end





--- All supported endpoints.
local g_Endpoints = {
	file = HandleEndpointGetFile,
	server_settings = HandleEndpointServerSettings,
	world_list = HandleEndpointGetWorlds,
	apply_changes = HandleEndpointApplyChanges,
	ping = HandleEndpointPing,
	restart_server = HandleEndpointRestartServer
}





--- Handles all incoming requests.
-- If no specific endpoint is requested it returns HTML
-- containing an iframe that points to the actual page.
-- Using an iframe has the advantage that all ajax calls
-- made will also point to /~webadmin which means no layout will be send.
-- The downside is that auto resizing gets a little more complicated.
function HandleWebRequest(a_Request)
	local requestedEndpoint = a_Request.Params["endpoint"] or
		a_Request.PostParams["endpoint"] or
		(a_Request.FormData["endpoint"] and a_Request.FormData["endpoint"].Value)
	
	if (requestedEndpoint) then
		if (g_Endpoints[requestedEndpoint]) then
			return g_Endpoints[requestedEndpoint](a_Request);
		end
		return "Unknown Endpoint"
	end
	
	-- Loading the page as an iframe has the advantage that all Ajax calls will automatically go to /~webadmin.
	return [[
	<style>
	#content-iframe {
		width:100%;
		min-height: 70vh;
		border: none;
	}
	</style>
	<script>
		function resizeIframe(obj) {
			obj.style.height = obj.contentWindow.document.documentElement.scrollHeight + 'px';
		}
		window.addEventListener("message", (event) => {
			let iframe = document.getElementById("content-iframe");
			resizeIframe(iframe);
		})
	</script>
	<iframe id="content-iframe"  onload="resizeIframe(this)" src="/~webadmin/]] .. g_PluginInfo.Name .. [[/Server+Settings/?endpoint=file&file=index">
	]]
end





