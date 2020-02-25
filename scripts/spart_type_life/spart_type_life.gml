/// @description spart_type_life(partType, life_min, life_max)
/// @param partType
/// @param life_min
/// @param life_max
/*
	Define the possible life span of each particle

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;
partType[| sPartTyp.LifeMin] = argument1;
partType[| sPartTyp.LifeMax] = argument2;