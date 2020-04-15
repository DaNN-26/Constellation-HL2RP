local PLUGIN = PLUGIN

PLUGIN.name = "FA:S 2 Support"
PLUGIN.description = "Adds support for FA:S 2."
PLUGIN.author = "liquid"

if not FAS2_Attachments then
    ix.log.AddRaw("Could not find FA:S 2 installed on the server.")
    return
end

-- generate attachment items

for k, v in pairs(FAS2_Attachments) do
    local uid = "fas2_" .. v.key
    local desc = ""

    for idx, entry in ipairs(v.desc) do
        desc = desc .. entry.t .. ((idx == #v.desc) and "" or "\n\n")
        if desc:sub(#desc, #desc) == "\n" then desc = desc:sub(1, #desc - 1) end
    end

    local ITEM = ix.item.Register(uid, nil, false, nil, true)
    ITEM.name = v.namemenu or v.namefull or v.nameshort or v.key
    ITEM.GetDescription = function(item)
        return desc
    end
    ITEM.fas2Attachment = v.key
    ITEM.model = "models/Items/BoxMRounds.mdl"
    ITEM.functions.Equip = {
        icon = "icon16/accept.png",
        OnRun = function(item)
            local client = item.player
            client:FAS2_PickUpAttachment(item.fas2Attachment)
            return false
        end,
        OnCanRun = function(item)
            if CLIENT then return true end

            local client = item.player
            if !IsValid(client) then return false end
            return client.FAS2Attachments[item.fas2Attachment] == nil
        end
    }
    ITEM.functions.Unequip = {
        icon = "icon16/cancel.png",
        OnRun = function(item)
            local client = item.player
            client:FAS2_RemoveAttachment(item.key)
            return false
        end,
        OnCanRun = function(item)
            if CLIENT then return true end

            local client = item.player
            if !IsValid(client) then return false end
            return client.FAS2Attachments[item.key] ~= nil
        end
    }
end

-- generate weapon/ammo items

local ammoCache = {}

for k, v in ipairs(weapons.GetList()) do
    if v.Category == "FA:S 2 Weapons" then
        -- weapons

        local ITEM = ix.item.Register(v.ClassName, "base_weapons", false, nil, true)
        ITEM.class = v.ClassName
        ITEM.GetName = function(item)
            local printName = weapons.Get(item.class).PrintName
            if printName == "Scripted Weapon" then
                return v.ClassName
            end
            return printName
        end
        ITEM.GetDescription = function(item)
            return "A weapon that uses " .. v.Primary.Ammo .. " ammo."
        end
        ITEM.model = v.WorldModel

        ALWAYS_RAISED[v.ClassName] = true

        -- ammo

        local function CreateAmmoType(ammoType, defaultClip)
            if not ammoType or ammoType == "none" then return end

            if ammoCache[ammoType] ~= nil then
                return
            end

            ammoCache[ammoType] = true

            local ITEM = ix.item.Register("fas2_" .. ammoType:lower(), "base_ammo", false, nil, true)
            ITEM.ammo = ammoType:lower()
            ITEM.ammoAmount = defaultClip or 1
            ITEM.model = "models/Items/BoxMRounds.mdl"
            ITEM.GetName = function(item)
                return ammoType .. " Ammo"
            end
            ITEM.GetDescription = function(item)
                return "Some " .. ammoType .. " rounds."
            end
        end

        CreateAmmoType(v.Primary.Ammo, v.Primary.DefaultClip)
        CreateAmmoType(v.Secondary.Ammo, v.Secondary.DefaultClip)
    end
end

-- FIX for weapon selection popping up when attaching attachments

if CLIENT then
    local wepselect = ix.plugin.Get("wepselect")
    if wepselect then
        if wepselect.hookedPlayerBindPress then
            HOOKS_CACHE["PlayerBindPress"][wepselect] = wepselect.origPlayerBindPress
        else
            wepselect.hookedPlayerBindPress = true
        end

        wepselect.origPlayerBindPress = wepselect.PlayerBindPress
        HOOKS_CACHE["PlayerBindPress"][wepselect] = function(_self, client, bind, pressed)
            local weapon = client:GetActiveWeapon()
            if IsValid(weapon)
            and weapon.IsFAS2Weapon
            and wep.dt.Status == FAS_STAT_CUSTOMIZE then
                return
            end

            wepselect:origPlayerBindPress(client, bind, pressed)
        end
    end
end

if SERVER then
    -- fix for raising/lowering weapons

    function PLUGIN:Think()
        for k, v in ipairs(player.GetAll()) do
            local weapon = v:GetActiveWeapon()
            
            if weapon.FireMode then
                v:SetNetVar("raised", weapon.FireMode ~= "safe")
            end
        end
    end
end

if CLIENT then
    -- disable ADS in third person

    function PLUGIN:CalcView()
        if ix.option.Get("thirdpersonEnabled", false) then
            local weapon = LocalPlayer():GetActiveWeapon()
            if weapon
            and weapon.dt
            and weapon.dt.Status == FAS_STAT_ADS then
                ix.option.Set("thirdpersonEnabled", false)
            end
        end
    end
end