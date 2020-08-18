/// @description smf_light_add_point(pos[3], radius, colour, intensity)
/// @param pos[3]
/// @param radius
/// @param colour
/// @param intensity
function smf_light_add_point(argument0, argument1, argument2, argument3) {
	//Returns the index of this light
	var i = (array_length_1d(SMF_lights) div 8) * 8;
	var pos = argument0;
	var radius = argument1;
	var col = argument2;
	var intensity = argument3;
	SMF_lights[i++] = pos[0];
	SMF_lights[i++] = pos[1];
	SMF_lights[i++] = pos[2];
	SMF_lights[i++] = radius;
	SMF_lights[i++] = colour_get_red(col) / 256;
	SMF_lights[i++] = colour_get_green(col) / 256;
	SMF_lights[i++] = colour_get_blue(col) / 256;
	SMF_lights[i++] = intensity;
	return i - 8;


}
