/// @param UIList
/// @param index

var list = argument0;
var index = argument1;

var effect = refid_get(list.entries[| index]);

if (!effect) {
    return c_black;
}

return effect.com_light ? effect.com_light.label_colour : c_red;