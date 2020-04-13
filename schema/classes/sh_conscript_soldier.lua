CLASS.name = "Combine Conscripted Forces"
CLASS.faction = FACTION_CONSCRIPT
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/combine_soldier.mdl")
	end
end
