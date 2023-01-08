data:extend({
	{
		type = "string-setting",
		name = "ChannelName",
		setting_type = "runtime-per-user",
		order = "0",
		allow_blank = true,
		auto_trim = true,
		default_value = "",
		hidden = false
	},
	{
		type = "bool-setting",
		name = "SpawnPollutionEnable",
		setting_type = "runtime-per-user",
		order = "1",
		default_value = false,
		forced_value = false,
		hidden = false
	},
	{
		type = "int-setting",
		name = "SpawnPollutionAmmount",
		setting_type = "runtime-per-user",
		order = "2",
		allowed_values = {10},
		default_value = 10,
		hidden = true
	},
	{
		type = "bool-setting",
		name = "TeleportEnable",
		setting_type = "runtime-per-user",
		order = "3",
		default_value = false,
		forced_value = false,
		hidden = false
	},
	{
		type = "int-setting",
		name = "TeleportRadius",
		setting_type = "runtime-per-user",
		order = "4",
		allowed_values = {10},
		default_value = 10,
		hidden = true
	},
	{
		type = "bool-setting",
		name = "ParanoiaEnable",
		setting_type = "runtime-per-user",
		order = "5",
		default_value = false,
		forced_value = false,
		hidden = false
	},
	{
		type = "int-setting",
		name = "ParanoiaRadius",
		setting_type = "runtime-per-user",
		order = "6",
		allowed_values = {100},
		default_value = 100,
		hidden = true
	},
	{
		type = "int-setting",
		name = "ParanoiaLimit",
		setting_type = "runtime-per-user",
		order = "7",
		allowed_values = {25},
		default_value = 25,
		hidden = true
	},
	{
		type = "bool-setting",
		name = "AttackEnable",
		setting_type = "runtime-per-user",
		order = "8",
		default_value = false,
		forced_value = false,
		hidden = false
	},
	{
		type = "int-setting",
		name = "AttackLimit",
		setting_type = "runtime-per-user",
		order = "9",
		allowed_values = {25},
		default_value = 25,
		hidden = true
	},
	{
		type = "string-setting",
		name = "AttackPreference",
		setting_type = "runtime-per-user",
		order = "10",
		allowed_values = {"Biter", "Spitter"},
		default_value = "Biter",
		hidden = false
	}
})