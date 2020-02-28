/// @param UIInput

var input = argument0;
var list = Stuff.map.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    var effect = list[| i];
    effect.com_light.light_radius = real(input.value);
}