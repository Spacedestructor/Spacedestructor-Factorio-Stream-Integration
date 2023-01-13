--{"pollution":1,"name":"ai_spacedestructor"}
--ChannelName, SpawnPollutionEnable, SpawnPollutionAmmount.
commands.add_command("SpawnPollution", nil, function(command)
	local ok, error = pcall(function()
		assert(game.is_multiplayer(), "Attempted use of Stream Integration Events in Singleplayer!")
		assert(command.player_index == nil, "Attempted Command usage via Ingame Chat!")
		local parameters = game.json_to_table(command.parameter) --pollution, name.
		assert(parameters.name, "Missing Channel Name!")
		local channelname = string.lower(parameters.name)
		local player = ParseName(channelname)
		assert(player, "Unable to find matching Player for Channel Name!")
		if player.mod_settings.SpawnPollutionEnable.value then
			local pollution = parameters["pollution"]
			if pollution == nil or pollution <= 0 then
				pollution = player.mod_settings["SpawnPollutionAmount"].value
			end
			player.surface.pollute(player.position, pollution)
		end
	end)
	if not ok then
		rcon.print(ok)
		log("Stream Integration has encountered an Error: " .. error)
	end
	rcon.print(ok)
	if not ok then
		log("Stream Integration has encountered an Error: " .. error)
	end
end)