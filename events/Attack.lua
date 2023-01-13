--{"limit":10,"name":"ai_spacedestructor"}
commands.add_command("Attack", nil, function(command)
	local ok, error = pcall(function()
		assert(game.is_multiplayer(), "Attempted use of Stream Integration Events in Singleplayer!")
		assert(command.player_index == nil, "Attempted Command usage via Ingame Chat!")
		local parameters = game.json_to_table(command.parameter) --limit, name.
		local channelname = parameters.name
		assert(parameters.name, "Missing Channel Name!")
		local player = ParseName(channelname)
		assert(player, "Unable to find matching Player for Channel Name!")
		local limit = parameters.limit
		if player.mod_settings.AttackEnable.value then
			if limit == nil or limit <= 0 then
				limit = player.mod_settings.AttackLimit
			end
			local entities = player.surface.find_entities_filtered { type = "unit-spawner", force = "enemy" }
			assert(entities, "No Possible Spawners found!")
			local closest_dist = math.huge
			local closest_spawner = nil
			for key, value in pairs(entities) do
				local distance = math.sqrt((value.position.x - player.position.x) ^ 2 + (value.position.y - player.position.y) ^ 2)
				if distance < closest_dist then
					closest_dist = distance
					closest_spawner = value
				end
			end
			assert(closest_spawner, "No Spawner Selected!")
			SpawnAttack(player, closest_spawner, limit)
		end
	end)
	rcon.print(ok)
	if not ok then
		log("Stream Integration has encountered an Error: " .. error)
	end
end)