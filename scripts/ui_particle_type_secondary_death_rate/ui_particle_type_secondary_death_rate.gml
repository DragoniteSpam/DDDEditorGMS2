/// @param UIInput

var input = argument0;
var type = input.root.type;
type.death_rate = real(input.value);
part_type_death(type.type, type.death_rate, type.death_type.type);