/// @param UICheckbox

var checkbox = argument0;
var type = checkbox.root.type;
type.sprite_animated = checkbox.value;
editor_particle_type_set_sprite(type);