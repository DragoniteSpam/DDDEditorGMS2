/// @param UIButton
function uivc_settings_game_base_screen_320(argument0) {

    var button = argument0;

    Stuff.game_screen_base_width = 320;
    Stuff.game_screen_base_height = 180;
    ui_input_set_value(button.root.el_screen_width, "320");
    ui_input_set_value(button.root.el_screen_height, "180");


}
