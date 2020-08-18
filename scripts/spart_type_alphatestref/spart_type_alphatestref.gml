/// @description spart_type_alphatestref(partType, alphaTestRef)
/// @param partType
/// @param alphaTestRef
function spart_type_alphatestref(argument0, argument1) {
	/*
		Toggles alpha testing for the given particle type.
		alphaTestRef should be between 0 and 255.

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partType = argument0;
	partType[| sPartTyp.AlphaTestRef] = argument1;


}
