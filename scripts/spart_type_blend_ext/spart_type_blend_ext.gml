/// @description spart_type_blend_ext(partType, src, dest, zwrite)
/// @param partType
/// @param src
/// @param dest
/// @param zwrite
/*
	Toggles blending and zwrite.
	Useful for additive effects like fire, or transparent effects like smoke.

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;
partType[| sPartTyp.BlendEnable] = true;
partType[| sPartTyp.BlendSrc] = argument1;
partType[| sPartTyp.BlendDst] = argument2;
partType[| sPartTyp.Zwrite] = argument3;