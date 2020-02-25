/// @description spart__emitter_activate(partEmitter)
/// @param partEmitter
/*
	Makes sure the emitter is on the active emitters list.
	This script is also responsible for sorting emitters by their particle type, so
	that emitters with the same particle type are drawn after one another.
	
	Script created by TheSnidr
	www.TheSnidr.com
*/
var partEmitter = argument0;
var partType = partEmitter[| sPartEmt.PartType];
if (partType < 0){exit;}
var partSystem = partEmitter[| sPartEmt.PartSystem];
var stepList = partSystem[| sPartSys.StepEmitterList];
var deathList = partSystem[| sPartSys.DeathEmitterList];
var emitterList = partSystem[| sPartSys.ActiveEmitterList];

//Make sure the emitter is on the active emitters list
if (ds_list_find_index(emitterList, partEmitter) < 0)
{
	var ind = max(0, ds_list_find_index(emitterList, partType));
	ds_list_insert(emitterList, ind, partEmitter);
	ds_list_insert(emitterList, ind, partType);
}

//Make sure the emitter is on the step emitters list
var stepType = partType[| sPartTyp.StepType];
if (stepType >= 0)
{
	if (ds_list_find_index(stepList, partEmitter) < 0)
	{
		var ind = max(0, ds_list_find_index(stepList, stepType));
		ds_list_insert(stepList, ind, partEmitter);
		ds_list_insert(stepList, ind, stepType);
	}
}

//Make sure the emitter is on the death emitters list
var deathType = partType[| sPartTyp.DeathType];
if (deathType >= 0)
{
	if (ds_list_find_index(deathList, partEmitter) < 0)
	{
		var ind = max(0, ds_list_find_index(deathList, deathType));
		ds_list_insert(deathList, ind, partEmitter);
		ds_list_insert(deathList, ind, deathType);
	}
}