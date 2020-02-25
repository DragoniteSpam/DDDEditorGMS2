/// @description spart_type_death(partType, num, childType)
/// @param partType
/// @param num
/// @param childType
/*
	Enables spawning a given number of secondary particles when the primary particle dies.
	Note that this effect does not stack, child particles can not spawn particles of their own.

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;
var deathNumber = argument1;
var deathType = argument2;
if (deathType[| sPartTyp.MeshEnabled])
{
	show_error("Error in script spart_type_death: Mesh particles cannot be secondary particles", false);
	exit;
}
partType[| sPartTyp.DeathNumber] = deathNumber;
partType[| sPartTyp.DeathType] = deathType;