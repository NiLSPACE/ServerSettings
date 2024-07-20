

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



local ComposableTarget =
{
    Target =
    {
        CategoryName = "Generator",
        OptionName = "Generator",
    },
    ExpectedValue = "Composable",
    Method = "equals"
}





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
                Name = "EndWorldName",
                Type = "options",
                SubOptions = CollectWorldNames()
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
            {
                Name = "Finishers",
                Type = "multi",
                SubOptions =
                {
                    "Animals", "BottomLava", "DeadBushes", "DirectOverhangs", "DirtPockets", "DistortedMembraneOverhangs", "DualRidgeCaves", "DungeonRooms", "EnderDragonFightStructures", "ForestRocks", "GlowStone", "Ice", "LavaLakes", "LavaSprings", "Lilypads", "MarbleCaves", "MineShafts", "NaturalPatches", "NetherClumpFoliage", "NetherOreNests", "OreNests", "OrePockets", "OverworldClumpFlowers", "PieceStructures", "PreSimulator", "Ravines", "RoughRavines", 
                    {
                        Title = "SinglePieceStructures",
                        Value = "SinglePieceStructures",
                        PossibleArguments = cFile:GetFolderContents("Prefabs/SinglePieceStructures")
                    },
                    -- "SinglePieceStructures",
                     "SoulsandRims", "Snow", "SprinkleFoliage", "TallGrass", "Trees", "Villages", "Vines", "WaterLakes", "WaterSprings", "WormNestCaves", 
                },
                Condition = ComposableTarget
            }
        }
    }
}