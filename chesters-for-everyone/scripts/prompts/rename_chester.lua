local rename = function(character, name)
	local response = "I renamed my Chester to " .. name .. "!"

	if character == "wilson" then
		response = "A fresh new name for you, " .. name .. "!"
	elseif character == "willow" then
		response = "Burn the old name! " .. name .. " is way better."
	elseif character == "wolfgang" then
		response = "Wolfgang call tiny chest " .. name .. " now!"
	elseif character == "wendy" then
		response = name .. ", a new name for my gloomy companion."
	elseif character == "wx78" then
		response = "SUCCESS: " .. name .. " DESIGNATION ACCEPTED"
	elseif character == "wickerbottom" then
		response = "Yes, " .. name .. ". Quite fitting, don't you think?"
	elseif character == "woodie" then
		response = "Alright, " .. name .. " it is, eh?"
	elseif character == "waxwell" then
		response = name .. ". It suits him, I suppose."
	elseif character == "wigfrid" then
		response = name .. "? A name fit för a warriör!"
	elseif character == "webber" then
		response = "He now goes by " .. name .. ". I think he likes it!"
	elseif character == "winona" then
		response = name .. ". A practical name for a practical friend."
	elseif character == "warly" then
		response = name .. ", a name as dependable as my best recipe!"
	elseif character == "wortox" then
		response = name .. "? A name with a touch of mischief!"
	elseif character == "wormwood" then
		response = "Chester friend now " .. name .. ". Good name."
	elseif character == "wurt" then
		response = name .. "? A name that fits his little, loyal heart!"
	elseif character == "walter" then
		response = name .. ", a great name for my best friend!"
	elseif character == "wanda" then
		response = "Time changes everything, even names. " .. name .. " it is."
	end

	return response
end

return rename
