/// @param UIInput

var input = argument0;
var type = input.root.type;
type.update_rate = real(input.value);

if (type.update_type) {
    part_type_step(type.type, ceil(type.update_rate / game_get_speed(gamespeed_fps)), type.update_type.type);
}