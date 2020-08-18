/// @description spart_emitter_stream(emitterInd, parttype, particleNumPerTime, lifeTime, dynamic)
/// @param emitterInd
/// @param parttype
/// @param particleNumPerTime
/// @param lifeTime
/// @param dynamic
function spart_emitter_stream(argument0, argument1, argument2, argument3, argument4) {
	/*
		Make an emitter stream a given number of particles per unit of time.
		Set lifeTime to negative to give it a (practically) infinite lifetime.
		Set dynamic to true if you'd like the particles that have already been created
		to finish drawing with the old settings.

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partEmitter = argument0;
	var partType = argument1;
	var partsPerStep = argument2;
	var lifeSpan = argument3;
	var dynamic = argument4;

	if (partType[| sPartTyp.MeshVbuff] >= 0 && partEmitter[| sPartEmt.Mesh] >= 0)
	{
		show_debug_message("Error in script spart_emitter_stream: Cannot use mesh particles for mesh emitters");
		exit;
	}

	//If dynamic change is activated, the old emitter is retired, and will live on until it dies
	if dynamic
	{
		var partSystem = partEmitter[| sPartEmt.PartSystem];
		if spart_emitter_retire(partEmitter, false)
		{
			partEmitter[| sPartEmt.CreationTime] = partSystem[| sPartSys.Time];
			partEmitter[| sPartEmt.StartMat] = partEmitter[| sPartEmt.EndMat];
			partEmitter[| sPartEmt.ID] = random(256 * 256);
		}
	}

	var partSystem = partEmitter[| sPartEmt.PartSystem];
	partEmitter[| sPartEmt.LifeSpan] = 9999999; //<--Arbitrary high number. The lifetime of a particle emitter
	if (lifeSpan > 0){partEmitter[| sPartEmt.LifeSpan] = lifeSpan;}
	partEmitter[| sPartEmt.PartType] = partType;
	partEmitter[| sPartEmt.ParticlesPerStep] = partsPerStep;
	if (partEmitter[| sPartEmt.EmitterType] != sPartEmitterType.Dynamic)
	{
		partEmitter[| sPartEmt.EmitterType] = sPartEmitterType.Stream;
	}
	spart__emitter_activate(partEmitter);


}
