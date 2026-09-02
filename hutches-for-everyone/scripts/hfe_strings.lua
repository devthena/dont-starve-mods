local strings = {
	system = {
		rename_disabled = "I can't do that in this server.",
		rename_usage = "Usage: /rename_hutch <name>",
		name_too_long = "That name is too long!",
		companion_missing = "Oh no... Hutch is missing!",
	},
	name_taken = {
		DEFAULT = "Hm, maybe another name.",
		wilson = "Hm, maybe a more unique name.",
		willow = "Boo! Boring. Pick something else.",
		wolfgang = "Wolfgang wants bigger, better name!",
		wendy = "Perhaps something less depressing...",
		wx78 = "INVALID NAME DETECTED.",
		wickerbottom = "A more refined name might suit better.",
		woodie = "How 'bout somethin' more one-of-a-kind?",
		wes = "...",
		waxwell = "You'll need to be more creative.",
		wathgrithr = "Aha! Cöme up with sömething grander!",
		webber = "We should pick a name that stands out!",
		winona = "Maybe something a bit more inventive.",
		warly = "A more distinctive name would do wonders!",
		wortox = "Not the most unique choice, little mortal.",
		wormwood = "Friend needs a name that blooms!",
		wurt = "Pick a name that stands out more, friend!",
		walter = "How about something more adventurous?",
		wanda = "Maybe something more unique, dear.",
	},
	private = {
		DEFAULT = "Hm, this is not my Hutch.",
		wilson = "I shouldn't snoop around.",
		willow = "I can't play with this Hutch.",
		wolfgang = "This is not Wolfgang's Hutch.",
		wendy = "Locked? I don't have the energy for this.",
		wx78 = "ACCESS DENIED.",
		wickerbottom = "This is not mine to meddle with.",
		woodie = "This ain't my Hutch, eh?",
		wes = "...",
		waxwell = "Privacy, hm? Very well.",
		wathgrithr = "A warriör respects the pröperty öf öthers.",
		webber = "This Hutch doesn't smell like ours.",
		winona = "Hey, this one's not mine.",
		warly = "Non, this Hutch is not mine.",
		wortox = "Hm, best to leave it alone.",
		wormwood = "Wormwood respects the locks.",
		wurt = "Not Wurt's Hutch!",
		walter = "I'll respect the privacy.",
		wanda = "Locked? A bit of mystery.",
	},
	rename = {
		DEFAULT = "I renamed my Hutch to {name}!",
		wilson = "Perfect! {name} it is!",
		willow = "Ha! {name} is way better.",
		wolfgang = "Wolfgang call tiny hutch {name}!",
		wendy = "{name}, a new name for my gloomy companion.",
		wx78 = "DESIGNATION ACCEPTED: {name}",
		wickerbottom = "Yes, {name}. It's quite fitting.",
		woodie = "Alright, {name} it is, eh?",
		wes = "...",
		waxwell = "{name}. It suits him, I suppose.",
		wathgrithr = "{name}? An hönörable name!",
		webber = "{name}? I think he likes it!",
		winona = "{name}, a practical name for a practical friend.",
		warly = "Oui, {name} is perfect!",
		wortox = "{name}, a name with a touch of mischief!",
		wormwood = "Hutch now {name}. Good name.",
		wurt = "{name}! It fits his little heart!",
		walter = "{name}, a great name for my best friend!",
		wanda = "{name}. Even names change with time.",
	},
}

local lang = TheSim:GetGameLanguage()
local ok, locale = pcall(require, "locale/" .. lang)

if ok then
	for group, entries in pairs(locale) do
		for k, v in pairs(entries) do
			strings[group][k] = v
		end
	end
end

return strings
