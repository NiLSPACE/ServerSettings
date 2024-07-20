






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
                Name = "Default Viewdistance",
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
            
            -- {
            --     Name = "ConditionTest",
            --     Type = "number",
            --     Description = "The amount of players allowed",
            --     Condition =
            --     {
            --         Target =
            --         {
            --             CategoryName = "Server",
            --             OptionName = "MaxPlayers"
            --         },
            --         ExpectedValue = "1",
            --         Method = "equals"
            --     }
            -- }
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
    -- {
    --     CategoryName = "Worlds",
    --     IsMultiKeyCategory = True,
    --     RequiredKey = "DefaultWorld",
    --     KeyName = "World"
    -- }
}