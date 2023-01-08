local function ErrorCheck(channelname, player) --input is channelname and player.
	local resolve = {
		channelname = {
			bool = false,
			msg = ""
		},
		player = {
			bool = false,
			msg = ""
		}
	}
	local result = pcall(assert(channelname, "Unable to Resolve Channel Name!"))	
	resolve.channelname.bool = result[1]
	resolve.channelname.msg = result[2]
	result = pcall(assert(player, "Unable to Resolve Player Refference from Channel Name!"))
	resolve.player.bool = result[1]
	resolve.player.msg = result[1]
	return resolve
end
local function ErrorHandle(resolve)
	if not resolve.channelname.bool then
		local text = "[Stream Integration] " .. resolve.channelname.msg
		game.print(text)
	elseif not resolve.player.bool then
		local text = "[Stream Integration] " .. resolve.player.msg
		game.print(text)
	end
end
local function ParseName(channelname) --channelname
	for key, value in pairs(game.players) do
		if value.mod_settings["ChannelName"].value == channelname then
			return game.get_player(value)
		end
	end
end
local function generate_unit_spawns(prototype, evolution, count) --entity name, evolution_factor, number of results to return.
	local prototype = game.entity_prototypes[prototype]
	assert(prototype, 'Entity prototype from which to spawn not found!')
	local unit_spawn_defs = prototype.result_units
	assert(unit_spawn_defs, 'Entity prototype is not a spawner!')
	local total = 0
	local units = {}
	for _, unit_spawn_def in ipairs(unit_spawn_defs) do
		local unit = unit_spawn_def.unit
		local spawn_points = unit_spawn_def.spawn_points
		local b = math.huge
		for i, spawn_point in ipairs(spawn_points) do
			if evolution < spawn_point.evolution_factor then
				b = i
				break
			end
		end
		local weight
		if b > #spawn_points then
			weight = spawn_points[#spawn_points].weight
		elseif b > 1 then
			local as = spawn_points[b - 1]
			local bs = spawn_points[b]
			local ax, ay = as.evolution_factor, as.weight
			local bx, by = bs.evolution_factor, bs.weight
			local t = (evolution - ax) / (bx - ax)
			weight = ay + t * (by - ay)
		else
			weight = spawn_points[1].weight
		end
		if weight > 0 then
			total = total + weight
			units[unit] = (units[unit] or 0) + weight
		end
	end
	local spawns = {}
	for i = 1, count do
		local remaining = total * math.random()
		for unit, weight in pairs(units) do
			spawns[i] = unit
			remaining = remaining - weight
			if remaining < 0 then
				break
			end
		end
	end
	return spawns
end
local function SpawnAttack(player, spawner, limit) --player, spawner, limit.
	local player = player
	local preference = player.mod_settings["AttackPreference"].value
	local limit = limit
	local biter_limit
	local spitter_limit
	local random = math.random(limit)
	if preference == "Biter" then
		biter_limit = random
		spitter_limit = limit - random
	elseif preference == "Spitter" then
		spitter_limit = random
		biter_limit = limit - random
	end
	local biter_spawns = {}
	biter_spawns = generate_unit_spawns("biter-spawner", game.forces["enemy"].evolution_factor, biter_limit)
	local spitter_spawns = {}
	spitter_spawns = generate_unit_spawns("spitter-spawner", game.forces["enemy"].evolution_factor, spitter_limit)
	local entities = {}
	for key, value in pairs(biter_spawns) do
		entities[key] = player.surface.create_entity{
			name=value,
			position=spawner.position,
			force="enemy",
			raise_built=false,
			create_built_effect_smoke=false,
			spawn_decorations=false,
			move_stuck_players=true
		}
		entities[key].set_command{
			type = defines.command.compound,
			structure_type = defines.compound_command.logical_and,
			commands = {
				{
					type = defines.command.go_to_location,
					destination_entity = player.character,
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
					target = player.character,
					distraction = defines.distraction.by_damage
				}
			}
		}
	end
	entities = nil
	local entities = {}
	for key, value in pairs(spitter_spawns) do
		entities[key] = player.surface.create_entity{
			name=value,
			position=spawner.position,
			force="enemy",
			raise_built=false,
			create_built_effect_smoke=false,
			spawn_decorations=false,
			move_stuck_players=true
		}
		entities[key].set_command{
			type = defines.command.compound,
			structure_type = defines.compound_command.logical_and,
			commands = {
				{
					type = defines.command.go_to_location,
					destination_entity = player.character,
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
					target = player.character,
					distraction = defines.distraction.by_damage
				}
			}
		}
	end
end
--ChannelName, SpawnPollutionEnable, SpawnPollutionAmmount.
commands.add_command("SpawnPollution",nil,function(command)
	if game.is_multiplayer() then
		if command.player_index == nil then
			local parameters = game.json_to_table(command.parameter) --pollution, name.
			local channelname = parameters["name"]
			local player = game.get_player(ParseName(channelname))
			local resolve = ErrorCheck(channelname, player)
			if resolve.channelname.bool and resolve.player.bool then
				local enable = player.mod_settings["SpawnPollutionEnable"].value
					if enable then
						local pollution_default = player.mod_settings["SpawnPollutionAmount"].value
						local pollution = parameters["pollution"]
						if pollution == nil or pollution <= 0 then
							pollution = pollution_default
						end
						player.surface.pollute(player.position, pollution)
					end
			else
				ErrorHandle(resolve)
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
--ChannelName, TeleportEnable, TeleportRadius.
commands.add_command("Teleport",nil,function(command)
	if game.is_multiplayer() then
		if command.player_index == nil then
			local parameters = game.json_to_table(command.parameter) --radius, name.
			local channelname = parameters["name"]
			local player = game.get_player(ParseName(channelname))
			local resolve = ErrorCheck(channelname, player)
			if resolve.channelname.bool and resolve.player.bool then
				local enable = player.mod_settings["TeleportEnable"].value
				if enable then
					local radius_default = player.mod_settings["TeleportRadius"].value
					local radius = parameters["radius"].value
					if radius == nil or radius <= 0 then
						radius = radius_default
					end
					local angle = math.random(0, 2) * math.pi()
					local offset = {x = 0, y = 0}
					offset.x = radius * math.cos(angle)
					offset.y = radius * math.sin(angle)
					local position = player.surface.find_non_colliding_position(player.character.name, player.position, radius, 1, true)
					player.teleport(position, player.surface)
				end
			else
				ErrorHandle(resolve)
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
--ChannelName, ParanoiaEnable
commands.add_command("Paranoia",nil,function(command)
	if game.is_multiplayer() then
		if command.player_index == nil then
			local parameters = game.json_to_table(command.parameter) --radius, limit, name.
			local channelname = parameters["name"]
			local player = game.get_player(ParseName(channelname))
			local resolve = ErrorCheck(channelname, player)
			if resolve.channelname.bool and resolve.player.bool then
				local enable = player.mod_settings["ParanoiaEnable"].value
				if enable then
					local radius_default = player.mod_settings["ParanoiaRadius"].value
					local radius = parameters["radius"]
					if radius == nil or radius <= 0 then
						radius = radius_default
					end
					local limit_default = player.mod_settings["ParanoiaLimit"].value
					local limit = parameters["limit"]
					if limit == nil or limit <= 0 then
						limit = limit_default
					end
					local entities = player.surface.find_entities_filtered{force=player.force} --Apparently you cant invert the radius or limit filters.
					local TableSize = 0
					for key, value in pairs(entities) do
						TableSize = TableSize + 1
					end
					local counter = 0
					for key, value in pairs(entities) do
						local distance = math.sqrt((value.position.x - player.position.x)^2 + (value.position.y - player.position.y)^2)
						if distance > radius and counter < limit then
							if value.type == "artillery-turret" or "ammo-turret" or "electric-turret" or "fluid-turret" then
								player.add_alert(value, defines.alert_type.turret_fire)
							else
								player.add_alert(value, defines.alert_type.entity_under_attack)
							end
							counter = counter + 1
						end
					end
				end
			else
				ErrorHandle(resolve)
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
			local parameters = game.json_to_table(command.parameter) --limit, name.
			local channelname = parameters["name"]
			local player = ParseName(channelname)
			local resolve = ErrorCheck(channelname, player)
			if resolve.channelname.bool and resolve.player.bool then
				local enable = player.mod_settings["AttackEnable"].value
				local limit_default = player.mod_settings["AttackLimit"]
				local limit = parameters["limit"]
				if enable then
					if limit == nil or limit <= 0 then
						limit = limit_default
					end
					local entities = player.surface.find_entities_filtered{type="unit-spawner",force="enemy"}
					local distance = {}
					for key, value in pairs(entities) do
						distance[value] = math.sqrt((value.position.x - player.position.x)^2 + (value.position.y - player.position.y)^2)
					end
					table.sort(distance)
					local spawner = distance[1]
					SpawnAttack(player, spawner, limit)
				end
			else
				ErrorHandle(resolve)
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