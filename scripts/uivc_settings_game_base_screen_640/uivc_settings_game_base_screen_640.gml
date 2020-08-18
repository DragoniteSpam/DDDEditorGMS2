/// @param UIButton
function uivc_settings_game_base_screen_640(argument0) {

	var button = argument0;

	Stuff.game_screen_base_width = 640;
	Stuff.game_screen_base_height = 360;
	ui_input_set_value(button.root.el_screen_width, "640");
	ui_input_set_value(button.root.el_screen_height, "360");


}
