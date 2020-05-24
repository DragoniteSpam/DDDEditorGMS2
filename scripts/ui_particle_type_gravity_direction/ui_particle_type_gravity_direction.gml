/// @param UIProgressBar

var bar = argument0;
var selection = ui_list_selection(bar.root.list);

if (selection + 1) {
    var type = Stuff.particle.types[| selection];
    type.gravity_direction = normalize_correct(bar.value, -180, 180);
    part_type_gravity(type.type, type.gravity, type.gravity_direction);
}