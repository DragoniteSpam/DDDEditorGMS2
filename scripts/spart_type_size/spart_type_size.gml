/// @description spart_type_size(partType, size_min, size_max, size_incr, size_acc)
/// @param partType
/// @param size_min
/// @param size_max
/// @param size_incr
/// @param size_acc
function spart_type_size(argument0, argument1, argument2, argument3, argument4) {
	/*
		Set the minimum and maximum starting size of the particles, as well as how much they should
		grow per step.

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partType = argument0;
	partType[| sPartTyp.Size] = [argument1, argument2, argument3, argument4];


}
