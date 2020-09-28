/// @description smf_light_add_directional(dir[3], colour, intensity)
/// @param dir[3]
/// @param colour
/// @param intensity
function smf_light_add_direction(argument0, argument1, argument2) {
    var i = (array_length(SMF_lights) div 8) * 8;
    var j = 0;
    var V = argument0;
    var col = argument1;
    SMF_lights[i++] = V[0];
    SMF_lights[i++] = V[1];
    SMF_lights[i++] = V[2];
    SMF_lights[i++] = 0;
    SMF_lights[i++] = colour_get_red(col) / 256;
    SMF_lights[i++] = colour_get_green(col) / 256;
    SMF_lights[i++] = colour_get_blue(col) / 256;
    SMF_lights[i++] = argument2;


}
