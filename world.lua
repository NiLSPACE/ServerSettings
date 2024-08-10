

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





local FluidSimulatorOptions =
{
    {
        Name = "Falloff",
        Type = "number",
    },
    {
        Name = "TickDelay",
        Type = "number",
    },
    {
        Name = "NumNeighborsForSource",
        Type = "number",
    }
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
        CategoryName = "Physics",
        Options =
        {
            {
                Name = "DeepSnow",
                Type = "bool",
            },
            {
                Name = "ShouldLavaSpawnFire",
                Type = "bool",
            },
            {
                Name = "TNTShrapnelLevel",
                Type = "number",
            },
            {
                Name = "WaterSimulator",
                Type = "options",
                SubOptions = {"Vanilla", "Floody", "Noop", "Vaporize"}
            },
            {
                Name = "LavaSimulator",
                Type = "options",
                SubOptions = {"Vanilla", "Floody", "Noop", "Vaporize"}
            },
            {
                Name = "RedstoneSimulator",
                Type = "options",
                SubOptions = {"Incremental", "Noop"}
            },
            {
                Name = "SandInstantFall",
                Type = "bool",
            },
        }
    },
    {
        CategoryName = "WaterSimulator",
        Options = FluidSimulatorOptions,
        Condition = CreateCondition("Physics", "WaterSimulator", Method.Equals, {"Vanilla", "Floody"})
    },
    {
        CategoryName = "LavaSimulator",
        Options = FluidSimulatorOptions,
        Condition = CreateCondition("Physics", "LavaSimulator", Method.Equals, {"Vanilla", "Floody"})
    },
    {
        CategoryName = "FireSimulator",
        Options =
        {
            {
                Name = "BurnStepTimeFuel",
                Type = "number",
            },
            {
                Name = "BurnStepTimeNonFuel",
                Type = "number",
            },
            {
                Name = "Flammability",
                Type = "number",
            },
            {
                Name = "ReplaceFuelChance",
                Type = "number",
            },
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
            { Name = "BiomeGen", Type = "header", Condition = ComposableTarget },
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
            
            { Name = "CheckerBoardBiomes",  Type = "multi",  Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "Checkerboard"), SubOptions = GetBiomeNames()},
            { Name = "CheckerBoardSize",    Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "Checkerboard")},

            { Name = "VoronoiCellSize",     Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "Voronoi")},
            { Name = "VoronoiJitterSize",   Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "Voronoi")},
            { Name = "VoronoiOddRowOffset", Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "Voronoi")},
            { Name = "VoronoiBiomes",       Type = "multi",  Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "Voronoi"), SubOptions = GetBiomeNames()},
            
            { Name = "DistortedVoronoiCellSize",     Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "DistortedVoronoi")},
            { Name = "DistortedVoronoiBiomes",       Type = "multi",  Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "DistortedVoronoi"), SubOptions = GetBiomeNames()},
            
            { Name = "MultiStepMapOceanCellSize",      Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "MultiStepMap")},
            { Name = "MultiStepMapMushroomIslandSize", Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "MultiStepMap")},
            { Name = "MultiStepMapRiverCellSize",      Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "MultiStepMap")},
            { Name = "MultiStepMapRiverWidth",         Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "MultiStepMap")},
            { Name = "MultiStepMapLandBiomeSize",      Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "MultiStepMap")},
            
            { Name = "TwoLevelLargeCellSize",       Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelSmallCellSize",       Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortXOctave1Freq", Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortXOctave1Amp",  Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortXOctave2Freq", Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortXOctave2Amp",  Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortXOctave3Freq", Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortXOctave3Amp",  Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortZOctave1Freq", Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortZOctave1Amp",  Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortZOctave2Freq", Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortZOctave2Amp",  Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortZOctave3Freq", Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            { Name = "TwoLevelDistortZOctave3Amp",  Type = "number", Condition = CreateCondition("Generator", "BiomeGen", Method.Equals, "TwoLevel")},
            
--------------------------------------------------------------------------------------
------------------------------------Shape Gen-----------------------------------------
--------------------------------------------------------------------------------------
            { Name = "ShapeGen", Type = "header", Condition = ComposableTarget },
            {
                Name = "ShapeGen",
                Type = "options",
                SubOptions =
                {
                    "BiomalNoise3D",
                    "Noise3D",
                    "HeightMap",
                    "DistortedHeightmap",
                    "TwoHeights",
                    "End",
                },

                Condition = ComposableTarget
            },
            { Name = "SeaLevel",                       Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DFrequencyX",        Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DFrequencyY",        Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DFrequencyZ",        Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DBaseFrequencyX",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DBaseFrequencyZ",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DChoiceFrequencyX",  Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DChoiceFrequencyY",  Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DChoiceFrequencyZ",  Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DAirThreshold",      Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DNumChoiceOctaves",  Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DNumDensityOctaves", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DNumBaseOctaves",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},
            { Name = "BiomalNoise3DBaseAmplitude",     Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "BiomalNoise3D")},

            { Name = "SeaLevel",                     Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "DistortedHeightmap")},
            { Name = "DistortedHeightmapFrequencyX", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "DistortedHeightmap")},
            { Name = "DistortedHeightmapFrequencyY", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "DistortedHeightmap")},
            { Name = "DistortedHeightmapFrequencyZ", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "DistortedHeightmap")},
            
            { Name = "EndGenMainIslandSize",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenIslandThickness",   Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenIslandYOffset",     Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenMainFrequencyX",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenMainFrequencyY",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenMainFrequencyZ",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenMainMinThreshold",  Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenSmallFrequencyX",   Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenSmallFrequencyY",   Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenSmallFrequencyZ",   Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            { Name = "EndGenSmallMinThreshold", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "End")},
            
            { Name = "TwoHeightsFrequencyX", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "TwoHeights")},
            { Name = "TwoHeightsFrequencyY", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "TwoHeights")},
            { Name = "TwoHeightsFrequencyZ", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "TwoHeights")},
            
            { Name = "Noise3DHeightAmplification", Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DMidPoint",            Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DFrequencyX",          Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DFrequencyY",          Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DFrequencyZ",          Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DBaseFrequencyX",      Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DBaseFrequencyZ",      Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DChoiceFrequencyX",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DChoiceFrequencyY",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DChoiceFrequencyZ",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DAirThreshold",        Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DNumChoiceOctaves",    Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DNumDensityOctaves",   Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DNumBaseOctaves",      Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
            { Name = "Noise3DBaseAmplitude",       Type = "number", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "Noise3D")},
--------------------------------------------------------------------------------------
------------------------------------Height Gen-----------------------------------------
--------------------------------------------------------------------------------------
            { Name = "HeightGen", Type = "header", Condition = CreateCondition("Generator", "ShapeGen", Method.Equals, "HeightMap")},
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
            { Name = "CompositionGen", Type = "header", Condition = ComposableTarget },
            {
                Name = "CompositionGen",
                Type = "options",
                SubOptions =
                {
                    "SameBlock",
                    "Biomal",
                    "Nether",
                    "End",
                    "Classic",
                },
                Condition = ComposableTarget
            },
            { Name = "SameBlockType", Type = "number", Condition = CreateCondition("Generator", "CompositionGen", Method.Equals, "SameBlock")},
            { Name = "NetherMaxThreshold", Type = "number", Condition = CreateCondition("Generator", "CompositionGen", Method.Equals, "Nether")},
            
--------------------------------------------------------------------------------------
------------------------------------Finishers-----------------------------------------
--------------------------------------------------------------------------------------
            { Name = "Finishers", Type = "header", Condition = ComposableTarget },
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
            { Name = "LavaLakesProbability",      Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "LavaLakes")},
            { Name = "WaterLakesProbability",     Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "WaterLakes")},
            { Name = "VinesLevel",                Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Vines") },

            { Name = 'DungeonRooms',              Type = 'header', Condition = CreateCondition("Generator", "Finishers", Method.Includes, "DungeonRooms")},
            { Name = "DungeonRoomsGridSize",      Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "DungeonRooms")},
            { Name = "DungeonRoomsMaxSize",       Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "DungeonRooms")},
            { Name = "DungeonRoomsMinSize",       Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "DungeonRooms")},
            { Name = "DungeonRoomsHeightDistrib", Type = "string", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "DungeonRooms")},

            { Name = 'Villages',                  Type = 'header', Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Villages")},
            { Name = "VillageGridSize",           Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Villages")},
            { Name = "VillageMaxOffset",          Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Villages")},
            { Name = "VillageMaxDepth",           Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Villages")},
            { Name = "VillageMaxSize",            Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Villages")},
            { Name = "VillageMinDensity",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Villages")},
            { Name = "VillageMaxDensity",         Type = "number", Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Villages") },
            { Name = "VillagePrefabs",            Type = "multi",  Condition = CreateCondition("Generator", "Finishers", Method.Includes, "Villages"), SubOptions = GetFilesWithoutExtensions("Prefabs/Villages"),  },

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