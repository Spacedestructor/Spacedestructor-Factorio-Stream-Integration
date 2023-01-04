commands.add_command("SpawnPollution",nil,function(command)
	if command.player_index == nil then
		local player = gui.player
		local parameter = tonumber(command.parameter) --first is the amount of pollution, second is the name who to target.
		player.surface.pollute(player.position, parameter)
	else
		local player = game.get_player(command.player_index)
		player.print("The Command " .. command.name .. " can only be used by the Stream Integration Mod!", player.chat_color)
	end
end)
commands.add_command("Teleport",nil,function(command)
	if command.player_index == nil then
		local player = gui.player
		local parameters = {} --first is the radius, second is the name.
		for key, value in string.gmatch(command.parameter, "%d") do
			parameters[key] = value
		end
		parameters[1] = tonumber(parameters[1])
		player.surface.find_non_colliding_position(player.name, player.position, parameters[1], 1, true)
	else
		local player = game.get_player(command.player_index)
		player.print("The Command " .. command.name .. " can only be used by the Stream Integration Mod!", player.chat_color)
	end
end)
command.add_command("Paranoia",nil,function(command)
	if command.player_index == nil then
		local player = gui.player
		local parameters = {} --first is the Radius, second is the Limit, third is the name who to target.
		for key, value in string.gmatch(command.parameter, "%d") do
			parameters[key] = value
		end
		parameters[1] = tonumber(parameters[1])
		parameters[2] = tonumber(parameters[2])
		local entities = player.surface.find_entities_filtered{force=player.force} --Apparently you cant invert the radius or limit filters.
		for key, value in pairs(entities) do
			local distance = math.sqrt((value.position.x - player.position.x)^2 + (value.position.y - player.position.y)^2)
			if distance <= parameters[1] then
				table.remove(entities, entities[key])
			end
		end
		local TableSize = 0
		for key, value in pairs(entities) do
			TableSize = TableSize + 1
		end
		while TableSize >= parameters[2] do
			table.remove(entities, math.random(TableSize))
			TableSize = TableSize - 1
		end
		for key, value in pairs(entities) do
			if entities[key].type == "artillery-turret" or "ammo-turret" or "electric-turret" or "fluid-turret" then
				player.add_alert(value, defines.alert_type.turret_fire)
			else
				player.add_alert(value, defines.alert_type.entity_under_attack)
			end
		end
	else
		local player = game.get_player(command.player_index)
		player.print("The Command " .. command.name .. " can only be used by the Stream Integration Mod!", player.chat_color)
	end
end)
command.add_command("Attack",nil,function(command) --first is how many biters/spitters should attack, second is the name who to target.
	local player = gui.player
	local parameters = {}
	for key, value in string.gmatch(command.parameter, "%d") do
		parameters[key] = value
	end
	parameters[1] = tonumber(parameters[1])
	local entities = player.surface.find_entities_filtered{type="unit",force="enemy"}
	local TableSize = 0
	for key, value in pairs(entities) do
		TableSize = TableSize + 1
	end
	while TableSize > parameters[1] do
		table.remove(entities, math.random(TableSize))
		TableSize = TableSize - 1
	end
	for key, value in pairs(entities) do
		value.set_command{
			type = defines.command.compound,
			structure_type = defines.compound_command.logical_and,
			command = {
				{
					type = defines.command.go_to_location,
					destination_entity = player,
					distraction = defines.distraction.by_anything,
					pathfind_flags = {
						allow_destroy_friendly_entities = false,
						allow_paths_through_own_entities = false,
						cache = false,
						prefer_straight_paths = false,
						low_priority = false,
						no_break = true
					},
					radius = 1
				},
				{
					type = defines.command.attack,
					target = player,
					distraction = defines.distraction.by_damage
				}
			}
		}
	end
end)