
--- Helper library for loading/getting faction information.
-- @module ix.faction

ix.faction = ix.faction or {}
ix.faction.teams = ix.faction.teams or {}
ix.faction.indices = ix.faction.indices or {}

local CITIZEN_MODELS = {
	"models/humans/group01/male_01.mdl",
	"models/humans/group01/male_02.mdl",
	"models/humans/group01/male_04.mdl",
	"models/humans/group01/male_05.mdl",
	"models/humans/group01/male_06.mdl",
	"models/humans/group01/male_07.mdl",
	"models/humans/group01/male_08.mdl",
	"models/humans/group01/male_09.mdl",
	"models/humans/group02/male_01.mdl",
	"models/humans/group02/male_03.mdl",
	"models/humans/group02/male_05.mdl",
	"models/humans/group02/male_07.mdl",
	"models/humans/group02/male_09.mdl",
	"models/humans/group01/male_40.mdl",
	"models/humans/group01/male_41.mdl",
	"models/humans/group01/male_38.mdl",
	"models/humans/group01/male_67.mdl",
	"models/humans/group01/male_75.mdl",
	"models/humans/group01/male_86.mdl",
	"models/humans/group01/male_96.mdl",
	"models/humans/group01/male_hc.mdl",
	"models/humans/group01/male_93.mdl",
	"models/humans/group01/male_83.mdl",
	"models/humans/group01/male_117.mdl",
	"models/humans/group01/male_122.mdl",
	"models/humans/group01/male_120.mdl",
	"models/humans/group01/male_115.mdl",
	"models/humans/group01/male_110.mdl",
	"models/humans/group01/male_111.mdl",
	"models/humans/group01/male_12.mdl",
	"models/humans/group01/male_51.mdl",
	"models/humans/group01/male_65.mdl",
	"models/humans/group01/male_63.mdl",
	"models/humans/group01/male_50.mdl",
	"models/humans/group01/male_49.mdl",
	"models/humans/group01/male_62.mdl",
	"models/humans/group01/male_70.mdl",
	"models/humans/group01/male_45.mdl",
	"models/barnes/refugee/female_31.mdl",
	"models/barnes/refugee/female_32.mdl",
	"models/barnes/refugee/female_34.mdl",
	"models/barnes/refugee/female_41.mdl",
	"models/barnes/refugee/female_42.mdl",
	"models/bloo_ltcom/citizens/male_10.mdl",
	"models/bloo_ltcom/citizens/male_11.mdl",
	"models/humans/group01/female_caterina.mdl",
	"models/humans/group01/female_01.mdl",
	"models/humans/group01/female_02.mdl",
	"models/humans/group01/female_03.mdl",
	"models/humans/group01/female_06.mdl",
	"models/humans/group01/female_07.mdl",
	"models/humans/group02/female_01.mdl",
	"models/humans/group02/female_03.mdl",
	"models/humans/group02/female_06.mdl",
	"models/humans/group01/female_04.mdl",
	"models/barnes/citizen/female_01.mdl",
	"models/barnes/citizen/female_02.mdl",
	"models/humans/group01/female_05.mdl",
	"models/humans/group01/female_40.mdl",
	"models/humans/group01/female_38.mdl",
	"models/humans/group01/female_28.mdl",
	"models/barnes/citizen/female_03.mdl",
	"models/barnes/citizen/female_04.mdl",
	"models/barnes/citizen/female_06.mdl",
	"models/barnes/citizen/female_07.mdl",
	"models/barnes/refugee/female_67.mdl",
	"models/barnes/refugee/female_28.mdl",
	"models/barnes/refugee/female_03.mdl",
	"models/barnes/refugee/female_06.mdl",
	"models/barnes/refugee/female_07.mdl",
	"models/barnes/refugee/female_04.mdl",
	"models/barnes/refugee/female_43.mdl",
	"models/barnes/refugee/female_25.mdl",
	"models/barnes/refugee/female_29.mdl",
	"models/barnes/refugee/female_43.mdl",
	"models/barnes/refugee/female_44.mdl",
	"models/humans/group01/female_78.mdl"
	
}

--- Loads factions from a directory.
-- @realm shared
-- @string directory The path to the factions files.
function ix.faction.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		FACTION = ix.faction.teams[niceName] or {index = table.Count(ix.faction.teams) + 1, isDefault = false}
			if (PLUGIN) then
				FACTION.plugin = PLUGIN.uniqueID
			end

			ix.util.Include(directory.."/"..v, "shared")

			if (!FACTION.name) then
				FACTION.name = "Unknown"
				ErrorNoHalt("Faction '"..niceName.."' is missing a name. You need to add a FACTION.name = \"Name\"\n")
			end

			if (!FACTION.description) then
				FACTION.description = "noDesc"
				ErrorNoHalt("Faction '"..niceName.."' is missing a description. You need to add a FACTION.description = \"Description\"\n")
			end

			if (!FACTION.color) then
				FACTION.color = Color(150, 150, 150)
				ErrorNoHalt("Faction '"..niceName.."' is missing a color. You need to add FACTION.color = Color(1, 2, 3)\n")
			end

			team.SetUp(FACTION.index, FACTION.name or "Unknown", FACTION.color or Color(125, 125, 125))

			FACTION.models = FACTION.models or CITIZEN_MODELS
			FACTION.uniqueID = FACTION.uniqueID or niceName

			for _, v2 in pairs(FACTION.models) do
				if (isstring(v2)) then
					util.PrecacheModel(v2)
				elseif (istable(v2)) then
					util.PrecacheModel(v2[1])
				end
			end

			if (!FACTION.GetModels) then
				function FACTION:GetModels(client)
					return self.models
				end
			end

			ix.faction.indices[FACTION.index] = FACTION
			ix.faction.teams[niceName] = FACTION
		FACTION = nil
	end
end

--- Retrieves a faction table.
-- @realm shared
-- @param identifier Index or name of the faction
-- @treturn table Faction table
-- @usage print(ix.faction.Get(Entity(1):Team()).name)
-- > "Citizen"
function ix.faction.Get(identifier)
	return ix.faction.indices[identifier] or ix.faction.teams[identifier]
end

--- Retrieves a faction index.
-- @realm shared
-- @string uniqueID Unique ID of the faction
-- @treturn number Faction index
function ix.faction.GetIndex(uniqueID)
	for k, v in ipairs(ix.faction.indices) do
		if (v.uniqueID == uniqueID) then
			return k
		end
	end
end

if (CLIENT) then
	--- Returns true if a faction requires a whitelist.
	-- @realm client
	-- @number faction Index of the faction
	-- @treturn bool Whether or not the faction requires a whitelist
	function ix.faction.HasWhitelist(faction)
		local data = ix.faction.indices[faction]

		if (data) then
			if (data.isDefault) then
				return true
			end

			local ixData = ix.localData and ix.localData.whitelists or {}

			return ixData[Schema.folder] and ixData[Schema.folder][data.uniqueID] == true or false
		end

		return false
	end
end
