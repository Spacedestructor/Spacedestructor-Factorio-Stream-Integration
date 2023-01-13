function GenerateUnitSpawns(prototype, evolution, count) --entity name, evolution_factor, number of results to return.
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