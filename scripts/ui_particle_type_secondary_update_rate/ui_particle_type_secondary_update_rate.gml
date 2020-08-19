/// @param UIInput
function ui_particle_type_secondary_update_rate(argument0) {

    var input = argument0;
    var type = input.root.type;
    type.update_rate = real(input.value);

    if (type.update_type) {
        var odds = editor_particle_rate_odds(type.update_rate);
        part_type_step(type.type, odds, type.update_type.type);
    }


}
