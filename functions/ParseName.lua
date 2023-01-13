function ParseName(channelname) --channelname
	for key, value in pairs(game.players) do
		if string.lower(value.mod_settings.ChannelName.value) == channelname then
			return value
		end
	end
end