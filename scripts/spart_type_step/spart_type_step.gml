/// @description spart_type_step(partType, num, childType)
/// @param partType
/// @param num
/// @param childType
function spart_type_step(argument0, argument1, argument2) {
	/*
		Enables particle trails by making each particle emit a given number of particles per unit of time.
		Note that this effect does not stack, child particles can not spawn particles of their own.

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partType = argument0;
	var stepNumber = argument1;
	var stepType = argument2;
	if (stepType[| sPartTyp.MeshEnabled])
	{
		show_error("Error in script spart_type_step: Mesh particles cannot be secondary particles", false);
		exit;
	}
	partType[| sPartTyp.StepNumber] = stepNumber;
	partType[| sPartTyp.StepType] = stepType;


}
