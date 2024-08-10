




function CollectPlugins()
    local output = {}
	cPluginManager:Get():ForEachPlugin(function(a_Plugin)
		table.insert(output, {
            Name =  a_Plugin:GetFolderName(),
            Type = "bool"
		 })
	end);
    return output;
end




function CollectWorldPaths()
    local output = {}
    cRoot:Get():ForEachWorld(function(a_World)
        local path = a_World:GetDataPath()
        table.insert(output, {
            Name = a_World:GetName(),
            OriginalValue = path,
            CurrentValue = path,
            Type = 'string'
        })
    end)
    return output;
end




function FillMultiKeyCategory(a_Ini, a_Category)
    local ini = cIniFile()
    if (not ini:ReadFile(a_Ini)) then
        error("Could not find ini file")
        return
    end
    local numValues = ini:GetNumValues(a_Category.CategoryName)
    local keyId = ini:FindKey(a_Category.CategoryName)
    local options = {}
    for i = 0, numValues - 1 do
        local valueName = ini:GetValueName(a_Category.CategoryName, i)
        local value = ini:GetValue(keyId, i)
        local optionName, title;
        if (valueName == a_Category.RequiredKey) then
            optionName = a_Category.RequiredKey
            title = optionName
        else
            optionName = valueName .. "&" .. i
            title = valueName
        end
        table.insert(options, {
            Name = optionName,
            Title = title,
            CurrentValue = value,
            OriginalValue = value,
            Type = "string"
        })
    end
    a_Category.Options = options
    return a_Category
end




function CollectWorlds()
    local output = {}
    local numNonRequiredKeys = 0;
    local function work(a_World)
        local key
        if (a_World == cRoot:Get():GetDefaultWorld()) then
            key = "DefaultWorld"
        else
            key = "World-" .. numNonRequiredKeys + 1
            numNonRequiredKeys = numNonRequiredKeys + 1
        end
        table.insert(output, {
            Name = key,
            Title = a_World == cRoot:Get():GetDefaultWorld() and "DefaultWorld" or "World",
            Type = "string",
            CurrentValue = a_World:GetName(),
            OriginalValue = a_World:GetName()
        })
    end
    cRoot:Get():ForEachWorld(work)
    return output
end





g_ServerSettingsOptions =
{
    {
        CategoryName = "Authentication",
        Options =
        {
            {
                Name = "Authenticate",
                Type = "bool",
                Description = "If enabled Cuberite checks if joining users are properly authenticated."
            },
            
            {
                Name = "AllowBungeeCord",
                Type = "bool",
                Description = "If enabled Cuberite allows connections through BungeeCord"
            },
            {
                Name = "OnlyAllowBungeeCord",
                Type = "bool",
                Description = "If enabled Cuberite only allows connections through BungeeCord"
            },
            {
                Name = "ProxySharedSecret",
                Type = "string",
                Description = "I have no idea what this does."
            },
            {
                Name = "Server",
                Type = "string",
                Description = "If authentication is enabled Cuberite checks the user on this server."
            },
            {
                Name = "Address",
                Type = "string",
                Description = "The URL (path and query) which is used for the request to the server."
            },
        },
    },
    {
        CategoryName = "Server",
        Options =
        {
            {
                Name = "Description",
                Type = "string",
                Description = "The description which users see in their server list."
            },
            {
                Name = "MaxPlayers",
                Type = "number",
                Description = "The amount of players allowed"
            },
            {
                Name = "Ports",
                Type = "number",
                Description = "The port on which the server runs"
            },
            {
                Name = "DefaultViewDistance",
                Type = "number",
                Description = "The radius of chunks a player can see around them."
            },
            {
                Name = "Hardcore",
                Type = "bool",
                Description = "Whether players play in hardcore mode or not."
            },
            {
                Name = "RequireResourcePack",
                Type = "bool",
                Description = "Wheter the player requires specific resource packs."
            },
            {
                Name = "ResourcePackUrl",
                Type = "string",
                Description = "The url where the resource pack can be downloaded from",
                Condition =
                {
                    Target =
                    {
                        CategoryName = "Server",
                        OptionName = "RequireResourcePack"
                    },
                    ExpectedValue = "1",
                    Method = "equals"
                }
            },
            {
                Name = "ShutdownMessage",
                Type = "string",
                Description = "The message send to players when they are disconnected from the server due to a shutdown or restart."
            },
        }
    },
    FillMultiKeyCategory("settings.ini", {
        CategoryName = "Worlds",
        IsMultiKeyCategory = true,
        RequiredKey = "DefaultWorld",
        KeyName = "World",
    }),
    {
        CategoryName = "WorldPaths",
        Options = CollectWorldPaths()
    },
    {
        CategoryName = "Plugins",
        Options = 
        {
            {
                Name = "Upload",
                Type = "upload",
                UploadUrl = "./?endpoint=upload_plugin"
            },
            unpack(CollectPlugins())
        }
    },
    {
        CategoryName = "MojangAPI",
        Options =
        {
            {
                Name = "NameToUUIDServer",
                Description = "The server to translate usernames to UUID's",
                Type = "string"
            },
            {
                Name = "NameToUUIDAddress",
                Description = "The address on the server to send requests to.",
                Type = "string"
            },
            {
                Name = "UUIDToProfileServer",
                Description = "The server to translate user UUID's to profiles",
                Type = "string"
            },
            {
                Name = "UUIDToProfileAddress",
                Description = "The address on the server to send requests to.",
                Type = "string"
            },
        }
    },
    {
        CategoryName = "RCON",
        Options =
        {
            {
                Name = "Enabled",
                Type = "bool",
                Description = "Whether RCON is enabled or not."
            }
        }
    },
    {
        CategoryName = "AntiCheat",
        Options =
        {
            {
                Name = "LimitPlayerBlockChanges",
                Type = "bool",
                Description = "Whether players are automatically kicked when they send too many block changes."
            }
        }
    },
    {
        CategoryName = "DeadlockDetect",
        Options =
        {
            {
                Name = "Enabled",
                Type = "bool",
                Description = "Whether the deadlock detector should be activated. This detects if the world threads are still running by checking if the world time has changed."
            },
            {
                Name = "IntervalSec",
                Type = "number",
                Description = "The time between deadlock checks."
            }
        }
    },
}