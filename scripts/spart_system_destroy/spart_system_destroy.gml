/// @description spart_system_destroy(partSystem)
/// @param partSystem
function spart_system_destroy(argument0) {
	/*
		Destroys the particle system and all emitters and particle types it contains

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partSystem = argument0;

	//Destroy emitters
	var emitterList = partSystem[| sPartSys.EmitterList];
	for (var i = ds_list_size(emitterList) - 1; i >= 0; i --)
	{
		ds_list_destroy(emitterList[| i]);
	}
	ds_list_destroy(emitterList);
	ds_list_destroy(partSystem[| sPartSys.StepEmitterList]);
	ds_list_destroy(partSystem[| sPartSys.DeathEmitterList]);
	ds_list_destroy(partSystem[| sPartSys.ActiveEmitterList]);

	//Destroy particle types
	var typeList = partSystem[| sPartSys.TypeList];
	for (var i = ds_list_size(typeList) - 1; i >= 0; i --)
	{
		spart_type_destroy(typeList[| i]);
	}
	ds_list_destroy(typeList);

	//Destroy particle system
	ds_list_destroy(partSystem);


}
