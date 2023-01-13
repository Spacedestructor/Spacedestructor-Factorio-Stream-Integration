--{"radius":100,"limit":25,"name":"ai_spacedestructor"}
--ChannelName, ParanoiaEnable
commands.add_command("Paranoia", nil, function(command)
	local ok, error = pcall(function()
		assert(game.is_multiplayer(), "Attempted use of Stream Integration Events in Singleplayer!")
		assert(command.player_index == nil, "Attempted Command usage via Ingame Chat!")
		local parameters = game.json_to_table(command.parameter) --radius, limit, name.
		local channelname = parameters.name
		assert(parameters.name, "Missing Channel Name!")
		local player = ParseName(channelname)
		assert(player, "Unable to find matching Player for Channel Name!")
		if player.mod_settings.ParanoiaEnable.value then
			local radius = parameters.radius
			if radius == nil or radius <= 0 then
				radius = player.mod_settings.ParanoiaRadius.value
			end
			local limit = parameters.limit
			if limit == nil or limit <= 0 then
				limit = player.mod_settings.ParanoiaLimit.value
			end
			local entities = player.surface.find_entities_filtered { force = player.force } --Apparently you cant invert the radius or limit filters.
			local TableSize = table_size(entities)
			while TableSize > limit do
				table.remove(entities, TableSize)
				TableSize = TableSize - 1
			end
			local counter = 0
			for key, value in pairs(entities) do
				local distance = math.sqrt((value.position.x - player.position.x) ^ 2 + (value.position.y - player.position.y) ^ 2)
				if distance > radius and counter < limit then
					if value.type == "artillery-turret" or "ammo-turret" or "electric-turret" or "fluid-turret" then
						player.add_alert(value, defines.alert_type.turret_fire)
					else
						player.add_alert(value, defines.alert_type.entity_under_attack)
					end
				end
				counter = counter + 1
			end
		end
	end)
	rcon.print(ok)
	if not ok then
		log("Stream Integration has encountered an Error: " .. error)
	end
end)