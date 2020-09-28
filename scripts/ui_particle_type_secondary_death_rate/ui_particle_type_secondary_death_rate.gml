/// @param UIInput
function ui_particle_type_secondary_death_rate(argument0) {

    var input = argument0;
    var type = input.root.type;
    type.death_rate = real(input.value);

    if (type.death_type) {
        part_type_death(type.type, type.death_rate, type.death_type.type);
    }


}
