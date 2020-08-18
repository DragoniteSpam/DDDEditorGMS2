/// @param UIInput
function uivc_npc_animate_speed(argument0) {

	var input = argument0;

	Stuff.setting_npc_animate_rate = real(input.value);
	setting_set("Config", "npc-speed", Stuff.setting_npc_animate_rate);


}
