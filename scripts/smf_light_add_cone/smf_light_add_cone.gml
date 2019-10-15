/// @description smf_light_add_cone(pos[3], dir[3], radius, angle)
/// @param dir[3]
/// @param col[3]
/// @param radius
/// @param angle
var i = (array_length_1d(SMF_lights) div 8) * 8;
var j = 0;
var pos = argument0;
var dir = argument1;
SMF_lights[i++] = pos[0];
SMF_lights[i++] = pos[1];
SMF_lights[i++] = pos[2];
SMF_lights[i++] = -argument2;
SMF_lights[i++] = dir[0];
SMF_lights[i++] = dir[1];
SMF_lights[i++] = dir[2];
SMF_lights[i++] = dcos(argument3);