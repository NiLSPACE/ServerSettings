




local function HandleEndpointGetWorlds(a_Request)
	local worlds = GetWorldSettings()
	return cJson:Serialize(worlds), "application/json"
end








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
	index =  {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "world-settings", "index.html"), mime = "text/html", finalizer=LinkEndpoints},
	["polyfills%-(%w+)%.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "world-settings", "polyfills-%1.js"), mime = "application/javascript" },
	["main%-(%w+)%.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "world-settings", "main-%1.js"), mime = "application/javascript" },
	["styles%-(%w+)%.css"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "world-settings", "styles-%1.css"), mime = "text/css" },
	["polyfills.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "world-settings", "polyfills.js"), mime = "application/javascript" },
	["main.js"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "world-settings", "main.js"), mime = "application/javascript" },
	["styles.css"] = {path = CreatePath(cPluginManager:GetCurrentPlugin():GetLocalFolder(), "lib", "world-settings", "styles.css"), mime = "text/css" },
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






local g_Endpoints;





function InitEndpointsWorld()
	g_Endpoints =
	{
		file = HandleEndpointGetFile,
		world_list = HandleEndpointGetWorlds,
		apply_changes = HandleEndpointApplyChanges,
		ping = HandleEndpointPing,
		restart_server = HandleEndpointRestartServer,
	}
end





--- Handles all incoming requests.
-- If no specific endpoint is requested it returns HTML
-- containing an iframe that points to the actual page.
-- Using an iframe has the advantage that all ajax calls
-- made will also point to /~webadmin which means no layout will be send.
-- The downside is that auto resizing gets a little more complicated.
function HandleWebRequest_World(a_Request)
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
	<iframe id="content-iframe"  onload="resizeIframe(this)" src="/~webadmin/]] .. g_PluginInfo.Name .. [[/World+Settings/?endpoint=file&file=index">
	]]
end