/// @param UIColorPicker
function ui_color_terrain_light_color(argument0) {

    var color = argument0;
    var mode = Stuff.terrain;

    var light = mode.lights[ui_list_selection(color.root.el_light_list)];
    light.color = color.value;


}
