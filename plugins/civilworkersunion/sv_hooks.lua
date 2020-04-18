
function PLUGIN:LoadData()
	self:LoadUnionLocks()
end

function PLUGIN:SaveData()
	self:SaveUnionLocks()
end

function PLUGIN:PlayerUse(client, entity)
	if (client:IsCombine() or client:GetCharacter():GetClass() == CLASS_CWU or IsValid(entity.ixUnionLock) and entity.ixUnionLock:HasKey(client)) then
		if (entity:IsDoor() and IsValid(entity.ixUnionLock) and client:KeyDown(IN_SPEED)) then
		entity.ixUnionLock:Toggle(client)
		return false
		end
	end
end