local bands = { --taka tablica, żeby nie zapierdalać po tabelach itemku
	["red"] = {Color(192, 57, 43),"Red Loyalist Armband"},
	["blue"] = {Color(41, 128, 185),"Blue Loyalist Armband"},
	["green"] = {Color(39, 174, 96),"Green Loyalist Armband"},
	["orange"] = {Color(255,128,0), "Orange Loyalist Armband"},
	["brown"] = {Color(102, 51, 51),"Brown Loyalist Armband"},
	["black"] = {Color(0,0,0), "Black Loyalist Armband"
	["violet"] = {Color(142, 68, 173),"Violet Loyalist Armband"}
	["white"] = {Color(221, 221, 221),"White Loyalist Armband"},
	["iron"] = {Color(15,0,15), "Iron Loyalist Armband"},
	["gold"] = {Color(153,128,0),"Gold Loyalist Armband"},
	["diamond"] = {Color(185,242,255), "Diamond Loyalist Armband"},
	["thermal"] = {Color(44,39,46), "Thermal Loyalist Armband"}
}

function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
	local band = client:GetNW2String("band",false) --string z typem opaski, czyli można rzec, że kolorem
	if band then --jako, że po zdjęciu banda NWString jest nilem to można zajebać takiego checka
		local panel = tooltip:AddRowAfter("name", "band")
		panel:SetBackgroundColor(bands[band][1]) 
		panel:SetText(bands[band][2])
		panel:SizeToContents()
    end
end	
