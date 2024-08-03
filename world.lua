

function CollectWorldNames()
    local worlds = {}
    cRoot:Get():ForEachWorld(function(a_World)
        table.insert(worlds, a_World:GetName())
    end)
    return worlds;
end


function GetWorldSettings()
    local worlds = {}
    cRoot:Get():ForEachWorld(function(a_World)
        local settings = MergeSettingsWithIni(a_World:GetIniFileName(), g_WorldSettings);
        table.insert(worlds,
        {
            WorldName = a_World:GetName(),
            Categories = settings,
        })
    end)
    return worlds
end



function GetAllMobNames()
    local lastMobType = mtZombieVillager
    local output = {}
    for i = 0, lastMobType do
        local mobName = cMonster:MobTypeToString(i)
        if (mobName ~= "") then
            table.insert(output, mobName)
        end
    end
    return output
end



local ComposableTarget =
{
    Target =
    {
        CategoryName = "Generator",
        OptionName = "Generator",
    },
    ExpectedValue = "Composable",
    Method = Method.Equals
}



function GetFilesWithoutExtensions(a_Path)
    local files = cFile:GetFolderContents(a_Path);
    for i, file in ipairs(files) do
        files[i] = file:match("(.+)%.%w+$")
    end
    return files;
end




function GetBiomeNames()
    local output = {}
    for i = biOcean, biNumVariantBiomes do
        local biomeName = BiomeToString(i)
        if (biomeName ~= "") then
            table.insert(output, biomeName);
        end
    end
    -- Cuberite translates biEnd to "Sky" and biNether to "Hell"
    table.insert(output, "End")
    table.insert(output, "Nether")
    table.sort(output);
    return output;
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



g_WorldSettings =
{
    {
        CategoryName = "General",
        Options =
        {
            {
                Name = "Dimension",
                Type = "options",
                SubOptions =
                {
                    "Overworld",
                    "Nether",
                    "End"
                }
            },
            {
                Name = "UnusedChunkCap",
                Type = "number",
            },
            {
                Name = "IsDaylightCycleEnabled",
                Type = "bool"
            }
        }
    },
    {
        CategoryName = "SpawnPosition",
        Options =
        {
            {
                Name = "X",
                Type = "number",
            },
            {
                Name = "Y",
                Type = "number",
            },
            {
                Name = "Z",
                Type = "number",
            },
            {
                Name = "MaxViewDistance",
                Type = "number",
            },
            {
                Name = "PregenerateDistance",
                Type = "number",
            },
        }
    },
    {
        CategoryName = "Storage",
        Options =
        {
            {
                Name = "Schema",
                Type = "options",
                SubOptions =
                {
                    "Default",
                    "Forgetful",
                }
            },
            {
                Name = "CompressionFactor",
                Type = "number",
            },
        }
    },
    {
        CategoryName = "LinkedWorlds",
        Options =
        {
            {
                Name = "NetherWorldName",
                Type = "options",
                SubOptions = CollectWorldNames()
            },
            {
                Name = "OverworldName",
                Type = "options",
                SubOptions = CollectWorldNames()
            },
            {
                Name = "EndWorldName",
                Type = "options",
                SubOptions = CollectWorldNames()
            }
        }
    },
    {
        CategoryName = "Mechanics",
        Options =
        {
            {
                Name = "CommandBlocksEnabled",
                Type = "bool",
            },
            {
                Name = "PVPEnabled",
                Type = "bool",
            },
            {
                Name = "FarmlandTramplingEnabled",
                Type = "bool",
            },
            {
                Name = "UseChatPrefixes",
                Type = "bool",
            },
            {
                Name = "MinNetherPortalWidth",
                Type = "number",
            },
            {
                Name = "MaxNetherPortalWidth",
                Type = "number",
            },
            {
                Name = "MinNetherPortalHeight",
                Type = "number",
            },
            {
                Name = "MaxNetherPortalHeight",
                Type = "number",
            },
        }
    },
    {
        CategoryName = "Monsters",
        Options =
        {
            {
                Name = "VillagersShouldHarvestCrops",
                Type = "bool",
            },
            {
                Name = "AnimalsOn",
                Type = "bool",
            },
            {
                Name = "Types",
                Type = "multi",
                SubOptions = GetAllMobNames()
            }
        }
    },
    {
        CategoryName = "Generator",
        Options =
        {
            {
                Name = "Generator",
                Type = "options",
                SubOptions =
                {
                    "Composable",
                    "Noise3D"
                }
            },
--------------------------------------------------------------------------------------
------------------------------Biome Gen-----------------------------------------
--------------------------------------------------------------------------------------
            {
                Name = "BiomeGen",
                Type = "options",
                SubOptions =
                {
                    "Constant",
                    "Voronoi",
                    "DistortedVoronoi",
                    "MultiStepMap",
                    "TwoLevel",
                    "Checkerboard",
                    "GrownProt",
                    "Grown",
                },

                Condition = ComposableTarget
            },
            {
                Name = "ConstantBiome",
                Type = "options",
                SubOptions = GetBiomeNames(),
                Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "Constant")
            },
--------------------------------------------------------------------------------------
------------------------------------Shape Gen-----------------------------------------
--------------------------------------------------------------------------------------
            {
                Name = "ShapeGen",
                Type = "options",
                SubOptions =
                {
                    "BiomalNoise3D",
                    "HeightMap",
                    "End",
                },

                Condition = ComposableTarget
            },

--------------------------------------------------------------------------------------
------------------------------------Height Gen-----------------------------------------
--------------------------------------------------------------------------------------
            {
                Name = "HeightGen",
                Type = "options",
                SubOptions =
                {
                    "Flat",
                    "Classic",
                },

                Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "HeightMap")
            },

            {
                Name = "FlatHeight",
                Type = "number",
                Condition = CreateCondition("Generator", "HeightGen", Method.Equals, "Flat")
            },

            { Name = "ClassicHeightFreq1", Type = "number", Condition = CreateCondition("Generator", "HeightGen", Method.Equals, "Classic")},
            { Name = "ClassicHeightFreq2", Type = "number", Condition = CreateCondition("Generator", "HeightGen", Method.Equals, "Classic")},
            { Name = "ClassicHeightFreq3", Type = "number", Condition = CreateCondition("Generator", "HeightGen", Method.Equals, "Classic")},
            { Name = "ClassicHeightAmp1",  Type = "number", Condition = CreateCondition("Generator", "HeightGen", Method.Equals, "Classic")},
            { Name = "ClassicHeightAmp2",  Type = "number", Condition = CreateCondition("Generator", "HeightGen", Method.Equals, "Classic")},
            { Name = "ClassicHeightAmp3",  Type = "number", Condition = CreateCondition("Generator", "HeightGen", Method.Equals, "Classic")},

--------------------------------------------------------------------------------------
------------------------------Composition Gen-----------------------------------------
--------------------------------------------------------------------------------------
            {
                Name = "CompositionGen",
                Type = "options",
                SubOptions =
                {
                    "Biomal",
                    "Nether",
                    "End",
                    "Classic",
                },
                Condition = ComposableTarget
            },
            { Name = "NetherMaxThreshold", Type = "number", Condition = CreateCondition("Generator", "CompositionGen", Method.Equals, "Nether")},
            
--------------------------------------------------------------------------------------
------------------------------------Finishers-----------------------------------------
--------------------------------------------------------------------------------------
            {
                Name = "Finishers",
                Type = "multi",
                SubOptions =
                {
                    "Animals", "BottomLava", "DeadBushes", "DirectOverhangs", "DirtPockets", "DistortedMembraneOverhangs", "DualRidgeCaves", "DungeonRooms", "EnderDragonFightStructures", "ForestRocks", "GlowStone", "Ice", "LavaLakes", "LavaSprings", "Lilypads", "MarbleCaves", "MineShafts", "NaturalPatches", "NetherClumpFoliage", "NetherOreNests", "OreNests", "OrePockets", "OverworldClumpFlowers", "PreSimulator", "Ravines", "RoughRavines", 
                    {
                        Title = "SinglePieceStructures",
                        Value = "SinglePieceStructures",
                        PossibleArguments = GetFilesWithoutExtensions("Prefabs/SinglePieceStructures")
                    },
                    {
                        Title = "PieceStructures",
                        Value = "PieceStructures",
                        PossibleArguments = GetFilesWithoutExtensions("Prefabs/PieceStructures")
                    },
                     "SoulsandRims", "Snow", "SprinkleFoliage", "TallGrass", "Trees", "Villages", "Vines", "WaterLakes", "WaterSprings", "WormNestCaves", 
                },
                Condition = ComposableTarget
            },
            { Name = "BottomLavaLevel",           Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "BottomLava")},

            { Name = 'Villages',                  Type = 'header', Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Village")},
            { Name = "VillageGridSize",           Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Village")},
            { Name = "VillageMaxOffset",          Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Village")},
            { Name = "VillageMaxDepth",           Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Village")},
            { Name = "VillageMaxSize",            Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Village")},
            { Name = "VillageMinDensity",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Village")},
            { Name = "VillageMaxDensity",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Village") },
            { Name = "VillagePrefabs",            Type = "multi",  Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Village"), SubOptions = GetFilesWithoutExtensions("Prefabs/Villages"),  },

            { Name = 'MineShafts',                Type = 'header', Condition = CreateCondition("Generator", "Finishers", Method.Includes, "MineShafts") },
            { Name = "MineShaftsGridSize",        Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "MineShafts") },
            { Name = "MineShaftsMaxOffset",       Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "MineShafts") },
            { Name = "MineShaftsMaxSystemSize",   Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "MineShafts") },
            { Name = "MineShaftsChanceCorridor",  Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "MineShafts") },
            { Name = "MineShaftsChanceCrossing",  Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "MineShafts") },
            { Name = "MineShaftsChanceStaircase", Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "MineShafts") },
            
            { Name = 'WormNestCaves',             Type = 'header', Condition = CreateCondition("Generator", "Finishers", Method.Includes, "WormNestCaves") },
            { Name = "WormNestCavesSize",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "WormNestCaves") },
            { Name = "WormNestCavesGrid",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "WormNestCaves") },
            { Name = "WormNestMaxOffset",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "WormNestCaves") },
            
            { Name = "RoughRavines",                       Type = "header", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesGridSize",               Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMaxOffset",              Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMaxSize",                Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMinSize",                Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMaxCenterWidth",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMinCenterWidth",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMaxRoughness",           Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMinRoughness",           Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMaxFloorHeightEdge",     Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMinFloorHeightEdge",     Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMaxFloorHeightCenter",   Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMinFloorHeightCenter",   Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMaxCeilingHeightEdge",   Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMinCeilingHeightEdge",   Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMaxCeilingHeightCenter", Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },
            { Name = "RoughRavinesMinCeilingHeightCenter", Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "RoughRavines") },

            { Name = "PreSimulator",              Type = "header", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "PreSimulator") },
            { Name = "PreSimulatorFallingBlocks", Type = "bool",   Condition = CreateCondition("Generator", "Finishers", Method.Includes, "PreSimulator") },
            { Name = "PreSimulatorWater",         Type = "bool",   Condition = CreateCondition("Generator", "Finishers", Method.Includes, "PreSimulator") },
            { Name = "PreSimulatorLava",          Type = "bool",   Condition = CreateCondition("Generator", "Finishers", Method.Includes, "PreSimulator") },
        }
    }
}