/// @description spart_particles_clear(partSystem)
/// @param partSystem
/*
	Clears all particles from the particle system.
	Does not destroy any emitters or particle types, only clears the particles that have already spawned.
	
	Script created by TheSnidr
	www.TheSnidr.com
*/
var partSystem = argument0;
var time = partSystem[| sPartSys.Time];

//Set the creation time of all active emitters to 0
var emitterList = partSystem[| sPartSys.ActiveEmitterList];
for (var i = ds_list_size(emitterList) - 1; i > 0; i -= 2)
{
	var partEmitter = emitterList[| i];
	var startM = partEmitter[| sPartEmt.StartMat];
	var endM = partEmitter[| sPartEmt.EndMat];
	var newM = array_create(16);
	var t2 = (time - partEmitter[| sPartEmt.CreationTime]) / partEmitter[| sPartEmt.LifeSpan];
	var t1 = 1 - t2;
	for (var j = 0; j < 16; j ++)
	{
		newM[j] = t1 * startM[j] + t2 * endM[j];
	}
	
	partEmitter[| sPartEmt.CreationTime] = 0;
	partEmitter[| sPartEmt.StartMat] = endM;
	partEmitter[| sPartEmt.LifeSpan] -= time - partEmitter[| sPartEmt.CreationTime];
}

//Set the timer of the particle system to 0
partSystem[| sPartSys.Time] = 0;