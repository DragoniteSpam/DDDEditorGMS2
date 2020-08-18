/// @description spart_emitter_create(partSystem)
/// @param partSystem
function spart_emitter_create(argument0) {
	/*
		Create an emitter

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partEmitter = ds_list_create();
	var partSystem = argument0;
	partEmitter[| sPartEmt.ID] = random(256);
	partEmitter[| sPartEmt.PartSystem] = partSystem;
	partEmitter[| sPartEmt.EmitterType] = sPartEmitterType.None;
	partEmitter[| sPartEmt.StartMat] = matrix_build_identity();
	partEmitter[| sPartEmt.EndMat] = matrix_build_identity();
	partEmitter[| sPartEmt.Shape] = spart_shape_sphere;
	partEmitter[| sPartEmt.Sector] = 360;
	partEmitter[| sPartEmt.Mesh] = -1;
	partEmitter[| sPartEmt.MeshPartNum] = 0;
	partEmitter[| sPartEmt.Parent] = -1;
	partEmitter[| sPartEmt.PartType] = -1;
	partEmitter[| sPartEmt.Distribution] = 0;
	partEmitter[| sPartEmt.LifeSpan] = 9999999;
	partEmitter[| sPartEmt.CreationTime] = partSystem[| sPartSys.Time];
	partEmitter[| sPartEmt.TimeOfDeath] = partEmitter[| sPartEmt.CreationTime] + partEmitter[| sPartEmt.LifeSpan];

	ds_list_add(partSystem[| sPartSys.EmitterList], partEmitter);
	return partEmitter;


}
