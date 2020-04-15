
FACTION.name = "Xenian Creatures"
FACTION.description = "A creatue originating in the realm of Xen that resides on Earth."
FACTION.color = Color(185, 185, 100, 255)
FACTION.isDefault = false

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("cid", id)

	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
end

FACTION_XEN = FACTION.index
