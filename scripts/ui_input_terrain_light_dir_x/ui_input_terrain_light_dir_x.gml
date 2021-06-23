/// @param UIProgressBar
function ui_input_terrain_light_dir_x(argument0) {

    var bar = argument0;
    var mode = Stuff.terrain;

    var light = mode.lights[ui_list_selection(bar.root.el_light_list)];
    light.x = bar.value * 2 - 1;

    if (light.x == 0 && light.y == 0 && light.z == 0) {
        light.z = -1;
    }


}
