/// @description spart_emitter_mature(emitterInd)
/// @param emitterInd
function spart_emitter_mature(argument0) {
	/*
		Matures the emitter so that it starts off with all particles already spawned

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partEmitter = argument0;
	var partType = partEmitter[| sPartEmt.PartType];
	if partType < 0{exit;}
	partEmitter[| sPartEmt.CreationTime] -= partType[| sPartTyp.LifeMax];
	var stepType = partType[| sPartTyp.StepType];
	if stepType >= 0
	{
		partEmitter[| sPartEmt.CreationTime] -= stepType[| sPartTyp.LifeMax];	
	}
	var deathType = partType[| sPartTyp.DeathType];
	if deathType >= 0
	{
		partEmitter[| sPartEmt.CreationTime] -= deathType[| sPartTyp.LifeMax];	
	}


}
