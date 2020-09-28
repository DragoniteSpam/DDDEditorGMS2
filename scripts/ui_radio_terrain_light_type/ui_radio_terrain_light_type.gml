/// @param UIRadioArray
function ui_radio_terrain_light_type(argument0) {

    var radio = argument0;
    var mode = Stuff.terrain;

    var light = mode.lights[| ui_list_selection(radio.root.root.el_light_list)];
    light.type = radio.value;

    uivc_terrain_light_enable_by_type(radio.root.root.el_light_list);


}
