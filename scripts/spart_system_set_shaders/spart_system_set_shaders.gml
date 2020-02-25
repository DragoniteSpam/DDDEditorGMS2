/// @description spart_system_set_shaders(partSystem, regShader, secondaryShader, meshShader, emitterMeshShader)
/// @param partSystem
/// @param regShader
/// @param secondaryShader
/// @param meshShader
/// @param emitterMeshShader
/*
	Lets you define custom particle shaders for the given particle system
	
	Script created by TheSnidr
	www.TheSnidr.com
*/
var partSystem = argument0;
var regShader = argument1
var secondaryShader = argument2;
var meshShader = argument3;
var emitterMeshShader = argument4;

partSystem[| sPartSys.RegShader] = regShader;
partSystem[| sPartSys.SecShader] = secondaryShader;
partSystem[| sPartSys.MeshShader] = meshShader;
partSystem[| sPartSys.EmitterMeshShader] = emitterMeshShader;