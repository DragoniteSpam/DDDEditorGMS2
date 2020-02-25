/// @description spart__emitter_set_uniforms(uniformIndex, emitterIndex, time);
/// @param uniformIndex
/// @param emitterIndex
/// @param time
/*
	Sets the uniforms for the emitter
	
	Script created by TheSnidr
	www.TheSnidr.com
*/
var i = argument0;
var partEmitter = argument1;
var time = argument2;
var g = sPartUniformGrid;
shader_set_uniform_f_array(g[# sPartUni.emStartMat, i],	partEmitter[| sPartEmt.StartMat]);
shader_set_uniform_f_array(g[# sPartUni.emEndMat, i],	partEmitter[| sPartEmt.EndMat]);
shader_set_uniform_f(g[# sPartUni.emLifeSpan, i], min(time - partEmitter[| sPartEmt.CreationTime], partEmitter[| sPartEmt.LifeSpan]));
shader_set_uniform_f(g[# sPartUni.emTimeAlive, i], time - partEmitter[| sPartEmt.CreationTime]);
shader_set_uniform_f(g[# sPartUni.emShapeDistrBurstID, i], partEmitter[| sPartEmt.Shape] + 4 * partEmitter[| sPartEmt.Distribution] + 12 * (partEmitter[| sPartEmt.ParticlesPerStep] != sPartBurstNum) + 24 * floor(partEmitter[| sPartEmt.ID])); //<-- shape ranges from 0 to 3, distribution ranges from 0 to 2
shader_set_uniform_f(g[# sPartUni.emPartsPerStep, i], partEmitter[| sPartEmt.ParticlesPerStep]);
shader_set_uniform_f(g[# sPartUni.emSector, i], pi * partEmitter[| sPartEmt.Sector] / 360);