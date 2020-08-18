/// @description spart_type_orientation(partType, ang_min, ang_max, ang_incr, ang_acc, ang_relative)
/// @param partType
/// @param ang_min
/// @param ang_max
/// @param ang_incr
/// @param ang_acc
/// @param ang_relative
function spart_type_orientation(argument0, argument1, argument2, argument3, argument4, argument5) {
	/*
		Define the starting angle and angular momentum (in degrees per step) of the particle
		ang_relative makes the particle point in its moving direction (plus its angle variable)

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partType = argument0;
	partType[| sPartTyp.Angle] = [degtorad(argument1), degtorad(argument2), degtorad(argument3), degtorad(argument4)];
	partType[| sPartTyp.AngleRel] = argument5;


}
