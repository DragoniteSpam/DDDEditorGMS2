/// @param UIInput
function ui_particle_type_life_min(argument0) {

    var input = argument0;
    var selection = ui_list_selection(input.root.list);

    if (selection + 1) {
        var type = Stuff.particle.types[selection];
        type.life_min = real(input.value);
        var f = game_get_speed(gamespeed_fps);
        part_type_life(type.type, type.life_min * f, type.life_max * f);
    }


}
