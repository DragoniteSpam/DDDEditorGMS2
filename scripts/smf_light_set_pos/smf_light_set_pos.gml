/// @description smf_light_set_pos(index, pos[3])
/// @param index
/// @param pos[3]
function smf_light_set_pos(argument0, argument1) {
    var i = argument0;
    var pos = argument1;
    SMF_lights[i++] = pos[0];
    SMF_lights[i++] = pos[1];
    SMF_lights[i++] = pos[2];


}
