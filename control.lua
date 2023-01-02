commands.add_command(
	"SpawnPollution",
	nil,
	function(command)
		local player = game.get_player(command.player_index)
		local position = player.position
		local surface = player.surface
		local pollution = command.parameter
		surface.pollute(position, pollution)
		local text = "[Twitch Integration] Spawned " .. tostring(pollution) .. " Pollution at your Position!"
		local color = player.chat_color
		player.print(text, color)
	end
)