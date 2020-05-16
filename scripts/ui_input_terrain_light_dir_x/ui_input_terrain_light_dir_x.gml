/// @param UIProgressBar

var bar = argument0;
var mode = Stuff.terrain;

var light = mode.lights[| ui_list_selection(bar.root.el_light_list)];
light.x = normalize(bar.value, -0.5, 0.5);

if (light.x == 0 && light.y == 0 && light.z == 0) {
    light.z = -1;
}