









--- Builds a file path from all parameters using cFile:GetPathSeparator as the separator.
-- Expects that all arguments are strings.
local function CreatePath(...)
	return table.concat({...}, cFile:GetPathSeparator())
end





local function LinkEndpoints(a_Content)
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
	index =  {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "server-settings", "index.html"), mime = "text/html", finalizer=LinkEndpoints},
	["polyfills%-(%w+)%.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "server-settings", "polyfills-%1.js"), mime = "application/javascript" },
	["main%-(%w+)%.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "server-settings", "main-%1.js"), mime = "application/javascript" },
	["styles%-(%w+)%.css"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "server-settings", "styles-%1.css"), mime = "text/css" },
	["polyfills.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "server-settings", "polyfills.js"), mime = "application/javascript" },
	["main.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "server-settings", "main.js"), mime = "application/javascript" },
	["styles.css"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "server-settings", "styles.css"), mime = "text/css" },
}





--- Endpoint that handles the loading/returning of the index page, it's javascript/css files and it's libraries
local function HandleEndpointGetFile(a_Request)
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







--- Endpoint that allows users to upload new plugins.
local function HandleEndpointUploadPlugin(a_Request)
	local json = a_Request.PostParams["files"];
	local zipname = a_Request.PostParams["zipname"];
	local decoded = cJson:Parse(json);
	local keys = Keys(decoded)
	local pluginName = zipname
	local hasRootFolder = #keys == 1 and not keys[1]:lower():match("%.lua$")
	if (hasRootFolder) then
		pluginName = keys[1]
	end
	local path = { "Plugins", pluginName }
	local function process(a_Path, a_Obj)
		cFile:CreateFolder(table.concat(a_Path, cFile:GetPathSeparator()))
		for k, v in pairs(a_Obj) do
			if (type(v) == "table") then
				-- a Folder
				process(pack(a_Path, k), v)
			else
				-- A file
				local content = Base64Decode(v);
				local path = a_Path
				local f = io.open(table.concat(pack(a_Path, k), cFile:GetPathSeparator()), "wb")
				f:write(content);
				f:close();
			end
		end
	end

	if (cFile:IsFolder(table.concat(path, cFile:GetPathSeparator()))) then
		return [["The plugin \"]] .. pluginName .. [[\" already exists"]], "application/json"
	end
	process(path, hasRootFolder and decoded[keys[1]] or decoded)

	cPluginManager:Get():RefreshPluginList()

	return cJson:Serialize({
		Name =  pluginName,
		Type = "bool"
	 }), "application/json"
end








local function HandleEndpointServerSettings(a_Request)
	local settings = MergeSettingsWithIni("settings.ini", g_ServerSettingsOptions)
	return cJson:Serialize(settings), "application/json"
end







--- All supported endpoints.
-- Initialized through InitEndpointsServer so the shared endpoint handlers are loaded.
local g_Endpoints;





--- Fills g_Endpoints with all supported endpoints.
function InitEndpointsServer()
	g_Endpoints = {
		file = HandleEndpointGetFile,
		server_settings = HandleEndpointServerSettings,
		apply_changes = HandleEndpointApplyChanges,
		ping = HandleEndpointPing,
		restart_server = HandleEndpointRestartServer,
		upload_plugin = HandleEndpointUploadPlugin
	}
end





--- Handles all incoming requests.
-- If no specific endpoint is requested it returns HTML
-- containing an iframe that points to the actual page.
-- Using an iframe has the advantage that all ajax calls
-- made will also point to /~webadmin which means no layout will be send.
-- The downside is that auto resizing gets a little more complicated.
function HandleWebRequest_Server(a_Request)
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





