/// @param UICheckbox

var checkbox = argument0;
var type = checkbox.root.type;
type.sprite_stretched = checkbox.value;
editor_particle_type_set_sprite(type);