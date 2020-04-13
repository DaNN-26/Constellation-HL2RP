
FACTION.name = "Combine Conscripted Forces"
FACTION.description = "The Old Fighters For The Glorious Universal Union"
FACTION.color = Color(160, 50, 50, 255)
FACTION.pay = 25
FACTION.models = {"models/combine_soldier.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	character:SetData("cid", id)

	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
	inventory:Add("pistol", 1)
	inventory:Add("pistolammo", 2)

end

function FACTION:OnTransfered(client)
	local character = client:GetCharacter()

	character:SetName(self:GetDefaultName())
	character:SetModel(self.models[1])
end

FACTION_CONSCRIPT = FACTION.index
