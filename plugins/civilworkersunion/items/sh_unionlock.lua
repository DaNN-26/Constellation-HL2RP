ITEM.name = "itemUnionLock"
ITEM.description = "A metal apparatus applied to doors."  --A metal apparatus applied to doors.
ITEM.price = 25
ITEM.model = "models/props_combine/combine_lock01.mdl"
ITEM.category = "Альянс"
ITEM.factions = {FACTION_CP}
ITEM.functions.Place = {
	OnRun = function(item)
		local data = {}
		data.start = item.player:GetShootPos()
		data.endpos = data.start + item.player:GetAimVector()*128
		data.filter = item.player
		
		if (IsValid(scripted_ents.Get("ix_unionlock"):SpawnFunction(item.player, util.TraceLine(data)))) then
			item.player:EmitSound("npc/roller/mine/rmine_blades_out3.wav", 100, 90)
		else
			return false
		end
	end
}