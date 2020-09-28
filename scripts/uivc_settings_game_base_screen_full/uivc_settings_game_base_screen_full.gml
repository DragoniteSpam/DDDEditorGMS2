/// @param UIButton
function uivc_settings_game_base_screen_full(argument0) {

    var button = argument0;

    Stuff.game_screen_base_width = -1;
    Stuff.game_screen_base_height = -1;
    ui_input_set_value(button.root.el_screen_width, "-1");
    ui_input_set_value(button.root.el_screen_height, "-1");


}
