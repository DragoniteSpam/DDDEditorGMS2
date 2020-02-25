/// @description spart_type_mesh_cullmode(partType, cullmode)
/// @param partType
/// @param cullmode
/*
	Lets you set the culling mode for the given particle type. Use the built-in constants:
		cull_noculling
		cull_clockwise
		cull_counterclockwise

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;
partType[| sPartTyp.CullMode] = argument1;