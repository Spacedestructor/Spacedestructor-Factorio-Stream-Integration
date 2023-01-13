function SpawnAttack(Player, Spawner, Limit) --Player, spawner, limit.
	local preference = Player.mod_settings.AttackPreference.value
	local biter_limit
	local limit = Limit
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
	biter_spawns = GenerateUnitSpawns("biter-spawner", game.forces.enemy.evolution_factor, biter_limit)
	local biter_amount = table_size(biter_spawns)
	local spitter_spawns = {}
	spitter_spawns = GenerateUnitSpawns("spitter-spawner", game.forces.enemy.evolution_factor, spitter_limit)
	local spitter_amount = table_size(spitter_spawns)
	local entities = {}
	for key, value in pairs(biter_spawns) do
		local position = Spawner.surface.find_non_colliding_position(value, Spawner.position, 5 + biter_amount, 1, true)
		entities[key] = Player.surface.create_entity {
			name = value,
			position = position,
			force = "enemy",
			raise_built = false,
			create_built_effect_smoke = false,
			spawn_decorations = false,
			move_stuck_Players = true
		}
		entities[key].set_command {
			type = defines.command.compound,
			structure_type = defines.compound_command.logical_and,
			commands = {
				{
					type = defines.command.go_to_location,
					destination_entity = Player.character,
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
					target = Player.character,
					distraction = defines.distraction.by_damage
				}
			}
		}
	end
	entities = nil
	entities = {}
	for key, value in pairs(spitter_spawns) do
		local position = Spawner.surface.find_non_colliding_position(value, Spawner.position, 5 + spitter_amount, 1, true)
		entities[key] = Player.surface.create_entity {
			name = value,
			position = position,
			force = "enemy",
			raise_built = false,
			create_built_effect_smoke = false,
			spawn_decorations = false,
			move_stuck_Players = true
		}
		entities[key].set_command {
			type = defines.command.compound,
			structure_type = defines.compound_command.logical_and,
			commands = {
				{
					type = defines.command.go_to_location,
					destination_entity = Player.character,
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
					target = Player.character,
					distraction = defines.distraction.by_damage
				}
			}
		}
	end
end