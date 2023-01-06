local SFSI = {
	ChannelName = {}, --player name is the key, channel name the value.
	SpawnPollutionEnable = {}, --player name is the key, settings value the value.
	SpawnPollutionAmmount = {}, --player name is the key, settings value the value.
	TeleportEnable = {}, --player name is the key, settings value the value.
	TeleportRadius = {}, --player name is the key, settings value the value.
	ParanoiaEnable = {}, --player name is the key, settings value the value.
	ParanoiaRadius = {}, --player name is the key, settings value the value.
	ParanoiaLimit = {}, --player name is the key, settings value the value.
	AttackEnable = {}, --player name is the key, settings value the value.
	AttackLimit = {} --player name is the key, settings value the value.
}
function ParseName(channelname)
	for key, value in pairs(SFSI.ChannelName) do
		if value == channelname then
			return key
		end
	end
end
script.on_event(defines.events.on_player_joined_game, function(event) --player_index, name, tick.
	if game.is_multiplayer() then
		local player = game.get_player(event.player_index)
		local player_name = player.name
		SFSI.ChannelName[player_name] = game.mod_setting_prototypes["ChannelName"]
		SFSI.SpawnPollutionEnable[player_name] = game.mod_setting_prototypes["SpawnPollution-Enable"]
		SFSI.SpawnPollutionAmmount[player_name] = game.mod_setting_prototypes["SpawnPollution-Pollution"]
		SFSI.TeleportEnable[player_name] = game.mod_setting_prototypes["Teleport-Enable"]
		SFSI.TeleportRadius[player_name] = game.mod_setting_prototypes["Teleport-Radius"]
		SFSI.ParanoiaEnable[player_name] = game.mod_setting_prototypes["Paranoia-Enable"]
		SFSI.ParanoiaRadius[player_name] = game.mod_setting_prototypes["Paranoia-Radius"]
		SFSI.ParanoiaLimit[player_name] = game.mod_setting_prototypes["Paranoia-Limit"]
		SFSI.AttackEnable[player_name] = game.mod_setting_prototypes["Attack-Enable"]
		SFSI.AttackLimit[player_name] = game.mod_setting_prototypes["Attack-Limit"]
	else
		local player = game.get_player(1)
		player.print("The Stream Integration Mod is only available in Multiplayer!", player.chat_color)
	end
end)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event) -- player_index, setting, setting_type, name, tick.
	if game.is_multiplayer() then
		local player = game.get_player(event.player_index)
		local player_name = player.name
		local setting_name = event.setting
		local setting_value = settings.player[setting_name].value
		SFSI.ChannelName[player_name] = game.mod_setting_prototypes["ChannelName"]
		SFSI.SpawnPollutionEnable[player_name] = game.mod_setting_prototypes["SpawnPollution-Enable"]
		SFSI.SpawnPollutionAmmount[player_name] = game.mod_setting_prototypes["SpawnPollution-Pollution"]
		SFSI.TeleportEnable[player_name] = game.mod_setting_prototypes["Teleport-Enable"]
		SFSI.TeleportRadius[player_name] = game.mod_setting_prototypes["Teleport-Radius"]
		SFSI.ParanoiaEnable[player_name] = game.mod_setting_prototypes["Paranoia-Enable"]
		SFSI.ParanoiaRadius[player_name] = game.mod_setting_prototypes["Paranoia-Radius"]
		SFSI.ParanoiaLimit[player_name] = game.mod_setting_prototypes["Paranoia-Limit"]
		SFSI.AttackEnable[player_name] = game.mod_setting_prototypes["Attack-Enable"]
		SFSI.AttackLimit[player_name] = game.mod_setting_prototypes["Attack-Limit"]
	else
		local player = game.get_player(1)
		player.print("The Stream Integration Mod is only available in Multiplayer!", player.chat_color)
	end
end)
script.on_event(defines.events.on_player_created, function(event) --player_index, name, tick.
	if game.is_multiplayer() then
		local player = game.get_player(event.player_index)
		local player_name = player.name
		SFSI.ChannelName[player_name] = game.mod_setting_prototypes["ChannelName"]
		SFSI.SpawnPollutionEnable[player_name] = game.mod_setting_prototypes["SpawnPollution-Enable"]
		SFSI.SpawnPollutionAmmount[player_name] = game.mod_setting_prototypes["SpawnPollution-Pollution"]
		SFSI.TeleportEnable[player_name] = game.mod_setting_prototypes["Teleport-Enable"]
		SFSI.TeleportRadius[player_name] = game.mod_setting_prototypes["Teleport-Radius"]
		SFSI.ParanoiaEnable[player_name] = game.mod_setting_prototypes["Paranoia-Enable"]
		SFSI.ParanoiaRadius[player_name] = game.mod_setting_prototypes["Paranoia-Radius"]
		SFSI.ParanoiaLimit[player_name] = game.mod_setting_prototypes["Paranoia-Limit"]
		SFSI.AttackEnable[player_name] = game.mod_setting_prototypes["Attack-Enable"]
		SFSI.AttackLimit[player_name] = game.mod_setting_prototypes["Attack-Limit"]
	else
		local player = game.get_player(1)
		player.print("The Stream Integration Mod is only available in Multiplayer!", player.chat_color)
	end
end)
commands.add_command("SpawnPollution",nil,function(command)
	if game.is_multiplayer() then
		if command.player_index == nil then
			if SFSI.SpawnPollutionEnable then
				local parameters = game.json_to_table(command.parameter) --pollution, name.
				local channelname = parameters["name"]
				local player = game.get_player(ParseName(channelname))
				local pollution_default = SFSI.SpawnPollutionAmmount[player]
				local pollution = parameters["pollution"]
				if pollution == nil or pollution <= 0 then
					pollution = pollution_default
				end
				player.surface.pollute(player.position, pollution)
			end
		else
			local player = game.get_player(command.player_index)
			player.print("[Stream Integration] The Command " .. command.name .. " can only be used by the Stream Integration Mod!", player.chat_color)
		end
	else
		local player = game.get_player(1)
		player.print("[Stream Integration] The Stream Integration Mod is only available in Multiplayer!", player.chat_color)
	end
end)
commands.add_command("Teleport",nil,function(command)
	if game.is_multiplayer() then
		if command.player_index == nil then
			if SFSI.TeleportEnable then
				local parameters = game.json_to_table(command.parameter) --radius, name.
				local channelname = parameters["name"]
				local player = game.get_player(ParseName(channelname))
				local radius_default = SFSI.TeleportRadius
				local radius = parameters["radius"]
				if radius == nil or radius <= 0 then
					radius = radius_default
				end
				local position = player.surface.find_non_colliding_position(player.name, player.position, radius, 1, true)
				player.teleport(position, player.surface)
			end
		else
			local player = game.get_player(command.player_index)
			player.print("[Stream Integration] The Command " .. command.name .. " can only be used by the Stream Integration Mod!", player.chat_color)
		end
	else
		local player = game.get_player(1)
		player.print("[Stream Integration] The Stream Integration Mod is only available in Multiplayer!", player.chat_color)
	end
end)
commands.add_command("Paranoia",nil,function(command)
	if game.is_multiplayer() then
		if command.player_index == nil then
			if SFSI.ParanoiaEnable then
				local parameters = game.json_to_table(command.parameter) --radius, limit, name.
				local channelname = parameters["name"]
				local player = game.get_player(ParseName(channelname))
				local radius_default = SFSI.ParanoiaRadius
				local radius = parameters["radius"]
				if radius == nil or radius <= 0 then
					radius = radius_default
				end
				local limit_default = SFSI.ParanoiaLimit
				local limit = parameters["limit"]
				if limit == nil or limit <= 0 then
					limit = limit_default
				end
				local entities = player.surface.find_entities_filtered{force=player.force} --Apparently you cant invert the radius or limit filters.
				for key, value in pairs(entities) do
					local distance = math.sqrt((value.position.x - player.position.x)^2 + (value.position.y - player.position.y)^2)
					if distance <= radius then
						table.remove(entities, entities[key])
					end
				end
				local TableSize = 0
				for key, value in pairs(entities) do
					TableSize = TableSize + 1
				end
				while TableSize >= limit do
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
			end
		else
			local player = game.get_player(command.player_index)
			player.print("[Stream Integration] The Command " .. command.name .. " can only be used by the Stream Integration Mod!", player.chat_color)
		end
	else
		local player = game.get_player(1)
		player.print("[Stream Integration] The Stream Integration Mod is only available in Multiplayer!", player.chat_color)
	end
end)
commands.add_command("Attack",nil,function(command)
	if game.is_multiplayer() then
		if command.player_index == nil then
			if SFSI.AttackEnable then
				local parameters = game.json_to_table(command.parameter) --limit, name.
				local channelname = parameters["name"]
				local player = game.get_player(ParseName(channelname))
				local limit_default = SFSI.AttackLimit
				local limit = parameters["limit"]
				if limit == nil or limit <= 0 then
					limit = limit_default
				end
				local entities = player.surface.find_entities_filtered{type="unit",force="enemy"}
				local TableSize = 0
				for key, value in pairs(entities) do
					TableSize = TableSize + 1
				end
				while TableSize > limit do
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
			end
		else
			local player = game.get_player(command.player_index)
			player.print("[Stream Integration] The Command " .. command.name .. " can only be used by the Stream Integration Mod!", player.chat_color)
		end
	else
		local player = game.get_player(1)
		player.print("[Stream Integration] The Stream Integration Mod is only available in Multiplayer!", player.chat_color)
	end
end)