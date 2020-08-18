/// @description spart_emitter_retire(partEmitter, forceRetire)
/// @param partEmitter
/// @param forceRetire
function spart_emitter_retire(argument0, argument1) {
	/*
		Deletes the selected emitter from the active emitters list, and adds
		a new, special emitter that will finish the old emitter's spawned particles

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partEmitter = argument0;
	var forceRetire = argument1;
	var partSystem = partEmitter[| sPartEmt.PartSystem];
	if partEmitter[| sPartEmt.EmitterType] != sPartEmitterType.Stream{exit;}

	//Check if sufficient time has passed since the previous emitter was retired
	if (!forceRetire && partSystem[| sPartSys.Time] < partEmitter[| sPartEmt.CreationTime] + min(partEmitter[| sPartEmt.LifeSpan], partSystem[| sPartSys.DynamicInterval]))
	{
		return false;
	}

	//Create a retired emitter, which is a modified duplicate of the original emitter
	var partType = partEmitter[| sPartEmt.PartType];
	var retiredEmitter = ds_list_create(); 
	ds_list_copy(retiredEmitter, partEmitter);
	retiredEmitter[| sPartEmt.Parent] = partEmitter;
	retiredEmitter[| sPartEmt.EmitterType] = sPartEmitterType.Retired;
	retiredEmitter[| sPartEmt.LifeSpan] = min(partEmitter[| sPartEmt.LifeSpan], partSystem[| sPartSys.Time] - partEmitter[| sPartEmt.CreationTime]);
	retiredEmitter[| sPartEmt.TimeOfDeath] = retiredEmitter[| sPartEmt.CreationTime] + retiredEmitter[| sPartEmt.LifeSpan] + partType[| sPartTyp.LifeMax];
	spart__emitter_replace(retiredEmitter, partEmitter);

	var stepType = partType[| sPartTyp.StepType];
	if (stepType >= 0)
	{
		retiredEmitter[| sPartEmt.TimeOfDeath] += stepType[| sPartTyp.LifeMax];
	}
	var deathType = partType[| sPartTyp.DeathType];
	if (deathType >= 0)
	{
		retiredEmitter[| sPartEmt.TimeOfDeath] += deathType[| sPartTyp.LifeMax];
	}

	return true;


}
