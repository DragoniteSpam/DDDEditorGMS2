/// @description spart_system_create(batchSizeArray)
/// @param batchSizeArray
/*
	Creates a new particle system.
	Here you can define the number of particles per batch. Each batch requires a 
	new vertex_submit, so if you plan to have a lot of particles, it's nice to have
	set this to a large value. However, it's also the minimum number of particles
	that can be submitted, so it shouldn't be too large either.
	You can define multiple batch sizes in an array, and the most sensible one at any
	time will be chosen.

	Script created by TheSnidr
	www.thesnidr.com
*/
var partSystem = ds_list_create();
partSystem[| sPartSys.Num] = 0;

if (argument_count == 1 && is_array(argument[0]))
{
	partSystem[| sPartSys.BatchSizeArray] = argument[0];
}
else if (argument_count > 0)
{
	var batchSizeArray = array_create(argument_count);
	for (var i = 0; i < argument_count; i ++)
	{
		batchSizeArray[i] = argument[i];
	}
	partSystem[| sPartSys.BatchSizeArray] = batchSizeArray;
}
else
{
	partSystem[| sPartSys.BatchSizeArray] = [256];
}

partSystem[| sPartSys.Time] = 0;
partSystem[| sPartSys.Dynamic] = 0;
partSystem[| sPartSys.DrawCalls] = 0;
partSystem[| sPartSys.ParticleNum] = 0;
partSystem[| sPartSys.TypeList] = ds_list_create();
partSystem[| sPartSys.EmitterList] = ds_list_create();
partSystem[| sPartSys.StepEmitterList] = ds_list_create();
partSystem[| sPartSys.DeathEmitterList] = ds_list_create();
partSystem[| sPartSys.ActiveEmitterList] = ds_list_create();

//Use asset_get_index, which either returns the shader index if the shader exists, or -1 if the shader does not exist
partSystem[| sPartSys.RegShader] = asset_get_index("sh_spart");
partSystem[| sPartSys.SecShader] = asset_get_index("sh_spart_sec");
partSystem[| sPartSys.MeshShader] = asset_get_index("sh_spart_mesh");
partSystem[| sPartSys.EmitterMeshShader] = asset_get_index("sh_spart_emittermesh");
partSystem[| sPartSys.DynamicInterval] = 1.;
spart__update_vbuffers(partSystem);

return partSystem;