/// @param UICheckbox
function ui_particle_type_sprite_random(argument0) {

    var checkbox = argument0;
    var type = checkbox.root.type;
    type.sprite_random = checkbox.value;
    editor_particle_type_set_sprite(type);


}
