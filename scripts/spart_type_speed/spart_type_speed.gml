/// @description spart_type_speed(partType, speed_min, speed_max, speed_acc, speed_jerk)
/// @param partType
/// @param speed_min
/// @param speed_max
/// @param speed_acc
/// @param speed_jerk
/*
	Set the starting speed (units per second) of the particle

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;

//Make sure the speed isn't 0
if (argument1 == 0){argument1 = 0.0001;}
if (argument2 == 0){argument2 = 0.0001;}

partType[| sPartTyp.Speed] = [argument1, argument2, argument3, argument4];