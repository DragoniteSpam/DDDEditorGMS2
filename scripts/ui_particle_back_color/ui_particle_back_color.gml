/// @param UIColorPicker
function ui_particle_back_color(argument0) {

    var picker = argument0;

    Stuff.particle.back_color = picker.value;
    setting_set("Particle", "back", picker.value);


}
