--{"radius":50,"name":"ai_spacedestructor"}
--ChannelName, TeleportEnable, TeleportRadius.
commands.add_command("Teleport", nil, function(command)
	local ok, error = pcall(function()
		assert(game.is_multiplayer(), "Attempted use of Stream Integration Events in Singleplayer!")
		assert(command.player_index == nil, "Attempted Command usage via Ingame Chat!")
		local parameters = game.json_to_table(command.parameter) --radius, name.
		local channelname = parameters.name
		assert(parameters.name, "Missing Channel Name!")
		local player = ParseName(channelname)
		assert(player, "Unable to find matching Player for Channel Name!")
		if player.mod_settings.TeleportEnable.value then
			local radius = parameters.radius
			if radius == nil or radius <= 0 then
				radius = player.mod_settings.TeleportRadius.value
			end
			local angle = math.random(0, 2) * math.pi
			local offset = { x = radius * math.cos(angle), y = radius * math.sin(angle) }
			local position = player.surface.find_non_colliding_position(player.character.name, offset, radius, 1, true)
			assert(position, "Unable to find non colliding Position!")
			player.teleport(position, player.surface)
		end
	end)
	rcon.print(ok)
	if not ok then
		log("Stream Integration has encountered an Error: " .. error)
	end
end)