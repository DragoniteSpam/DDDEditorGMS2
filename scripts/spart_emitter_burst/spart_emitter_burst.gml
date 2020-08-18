/// @description part_emitter_burst(emitterInd, parttype, number, dynamic)
/// @param partSystem
/// @param parttype
/// @param number
/// @param dynamic
function spart_emitter_burst(argument0, argument1, argument2, argument3) {
	/*
		Makes the emitter emit only the given number of particles all at once, before becoming inactive.

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partEmitter = argument0;
	var partType = argument1;
	var partNum = argument2;
	var dynamic = argument3;
	if dynamic
	{
		var partSystem = partEmitter[| sPartEmt.PartSystem];
		if spart_emitter_retire(partEmitter, true)
		{
			partEmitter[| sPartEmt.CreationTime] = partSystem[| sPartSys.Time];
			partEmitter[| sPartEmt.StartMat] = partEmitter[| sPartEmt.EndMat];
		}
	}

	var partSystem = partEmitter[| sPartEmt.PartSystem];
	partEmitter[| sPartEmt.PartType] = partType;
	partEmitter[| sPartEmt.ParticlesPerStep] = sPartBurstNum;
	if (partEmitter[| sPartEmt.EmitterType] != sPartEmitterType.Dynamic)
	{
		partEmitter[| sPartEmt.EmitterType] = sPartEmitterType.Stream;
	}
	partEmitter[| sPartEmt.CreationTime] = partSystem[| sPartSys.Time];
	partEmitter[| sPartEmt.LifeSpan] = partNum / partEmitter[| sPartEmt.ParticlesPerStep];
	partEmitter[| sPartEmt.ID] = random(256 * 256);
	spart__emitter_activate(partEmitter);


}
