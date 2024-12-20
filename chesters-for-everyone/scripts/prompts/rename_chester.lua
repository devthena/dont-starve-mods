local rename = function(character, name)
	local response = "I renamed my Chester to " .. name .. "!"

	if character == "wilson" then
		response = "Perfect! " .. name .. " it is!"
	elseif character == "willow" then
		response = "Ha! " .. name .. " is way better."
	elseif character == "wolfgang" then
		response = "Wolfgang call tiny chest " .. name .. " now!"
	elseif character == "wendy" then
		response = name .. ", a new name for my gloomy companion."
	elseif character == "wx78" then
		response = "DESIGNATION ACCEPTED: " .. name
	elseif character == "wickerbottom" then
		response = "Yes, " .. name .. ". It's quite fitting."
	elseif character == "woodie" then
		response = "Alright, " .. name .. " it is, eh?"
	elseif character == "wes" then
		response = "..."
	elseif character == "waxwell" then
		response = name .. ". It suits him, I suppose."
	elseif character == "wigfrid" then
		response = name .. "? What an hönörable name!"
	elseif character == "webber" then
		response = name .. "? I think he likes it!"
	elseif character == "winona" then
		response = name .. ", a practical name for a practical friend."
	elseif character == "warly" then
		response = "Oui, " .. name .. " is perfect!"
	elseif character == "wortox" then
		response = name .. ", a name with a touch of mischief!"
	elseif character == "wormwood" then
		response = "Chester friend now " .. name .. ". Good name."
	elseif character == "wurt" then
		response = name .. "! It fits his little, loyal heart!"
	elseif character == "walter" then
		response = name .. ", a great name for my best friend!"
	elseif character == "wanda" then
		response = name .. ". Time changes everything, even names."
	end

	return response
end

return rename
