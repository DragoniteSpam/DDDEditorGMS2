/// @description spart_system_draw(partSystem, timeIncrement)
/// @param partSystem
/// @param timeIncrement
function spart_system_draw(argument0, argument1) {
	/*
		Increments time and draws the particle system.
		This script is also responsible for cleaning up emitters that no longer emit particles

		Script created by TheSnidr
		www.thesnidr.com
	*/
	//Arguments
	var partSystem = argument0;
	var timeIncrement = argument1;

	//System settings
	partSystem[| sPartSys.Time] += timeIncrement;
	partSystem[| sPartSys.ParticleNum] = 0;
	partSystem[| sPartSys.DrawCalls] = 0;
	var time = partSystem[| sPartSys.Time];

	//GPU settings
	var gpu_state = gpu_get_state();
	ds_map_destroy(gpu_state);

	//Initialize temporary variables
	var prevPartType = -1;
	var stepList = partSystem[| sPartSys.StepEmitterList];
	var stepNum = ds_list_size(stepList);
	var deathList = partSystem[| sPartSys.DeathEmitterList];
	var deathNum = ds_list_size(deathList);
	var emitterList = partSystem[| sPartSys.ActiveEmitterList];
	var emitterNum = ds_list_size(emitterList);

	//Make sure the necessary shaders have been compiled
	var regShader = partSystem[| sPartSys.RegShader];
	var meshShader = partSystem[| sPartSys.MeshShader];
	var emitterMeshShader = partSystem[| sPartSys.EmitterMeshShader];
	if (regShader >= 0 && !shader_is_compiled(regShader)){regShader = -1;}
	if (meshShader >= 0 && !shader_is_compiled(meshShader)){meshShader = -1;}
	if (emitterMeshShader >= 0 && !shader_is_compiled(emitterMeshShader)){emitterMeshShader = -1;}

	//Draw secondary particles
	if (stepNum || deathNum)
	{
		var shader = partSystem[| sPartSys.SecShader];
		if (shader >= 0 && shader_is_compiled(shader))
		{
			shader_set(shader);
			var uniformIndex = spart__get_uniform_index(shader);
		
			/////////////////////////////////////////////
			//Draw step particle effects
			for (var i = stepNum - 1; i > 0; i -= 2)
			{
				var partEmitter = stepList[| i];
				var partType = stepList[| i - 1];
				if (partType != prevPartType)
				{
					prevPartType = partType;
					spart__type_set_gpu_settings(partType);
					spart__type_set_uniforms(uniformIndex, partType);
					var parentType = partEmitter[| sPartEmt.PartType];
					spart__type_set_parent_uniforms(uniformIndex, parentType, true);
					var particlesPerParent = ceil(parentType[| sPartTyp.StepNumber] * min(parentType[| sPartTyp.LifeMax], partType[| sPartTyp.LifeMax]));
					var partLife = parentType[| sPartTyp.LifeMax] + partType[| sPartTyp.LifeMax];
				}
				spart__emitter_set_uniforms(uniformIndex, partEmitter, time);
				var parentPartNum = min(partLife, partEmitter[| sPartEmt.LifeSpan], time - partEmitter[| sPartEmt.CreationTime]) * partEmitter[| sPartEmt.ParticlesPerStep];
				spart__submit_particles(partSystem, partEmitter, partType, ceil(particlesPerParent * parentPartNum), uniformIndex);
			}
		
			/////////////////////////////////////////////
			//Draw death particle effects
			prevPartType = -1;
			for (var i = deathNum - 1; i > 0; i -= 2)
			{
				var partEmitter = deathList[| i];
				var partType = deathList[| i - 1];
				if (partType != prevPartType)
				{
					prevPartType = partType;
					spart__type_set_gpu_settings(partType);
					spart__type_set_uniforms(uniformIndex, partType);
					var parentType = partEmitter[| sPartEmt.PartType];
					spart__type_set_parent_uniforms(uniformIndex, parentType, false);
					var particlesPerParent = parentType[| sPartTyp.DeathNumber];
					var partLife = parentType[| sPartTyp.LifeMax] + partType[| sPartTyp.LifeMax] - parentType[| sPartTyp.LifeMin];
				}
				spart__emitter_set_uniforms(uniformIndex, partEmitter, time);
				var parentPartNum = min(partLife, partEmitter[| sPartEmt.LifeSpan], time - partEmitter[| sPartEmt.CreationTime]) * partEmitter[| sPartEmt.ParticlesPerStep];
				spart__submit_particles(partSystem, partEmitter, partType, ceil(particlesPerParent * parentPartNum), uniformIndex);
			}
		}
	}

	//Loop through active emitters
	for (var i = emitterNum - 1; i > 0; i -= 2)
	{
		var partEmitter = emitterList[| i];
		var partType = partEmitter[| sPartEmt.PartType];
		var emitterType = partEmitter[| sPartEmt.EmitterType];
		var emitterMesh = partEmitter[| sPartEmt.Mesh];
	
		/////////////////////////////////////////////
		//Retire active emitters that have lived longer than their life span
		if (emitterType == sPartEmitterType.Stream && time >= partEmitter[| sPartEmt.CreationTime] + partEmitter[| sPartEmt.LifeSpan])
		{
			spart_emitter_retire(partEmitter, true);
		}
	
		/////////////////////////////////////////////
		//Delete retired emitters whose particles are all dead
		if (emitterType == sPartEmitterType.Retired && time >= partEmitter[| sPartEmt.TimeOfDeath])
		{
			spart__emitter_deactivate(partEmitter);
			ds_list_destroy(partEmitter);
			var j = ds_list_find_index(partSystem[| sPartSys.EmitterList], partEmitter);
			if j >= 0
			{
				ds_list_delete(partSystem[| sPartSys.EmitterList], j);
			}
			continue;
		}
	
		/////////////////////////////////////////////
		//Draw regular particles
		if (partType != prevPartType || emitterMesh)
		{
			var shader = (emitterMesh ? emitterMeshShader : (partType[| sPartTyp.MeshEnabled] ? meshShader : regShader));
			if (shader < 0){continue;}	//Shader does not exist, can't draw this emitter
			shader_set(shader);
			var uniformIndex = spart__get_uniform_index(shader);
			spart__type_set_uniforms(uniformIndex, partType);
			spart__type_set_gpu_settings(partType);
			prevPartType = partType;
		}
		spart__emitter_set_uniforms(uniformIndex, partEmitter, time);
		var partNum = ceil(min(partType[| sPartTyp.LifeMax], partEmitter[| sPartEmt.LifeSpan], time - partEmitter[| sPartEmt.CreationTime]) * partEmitter[| sPartEmt.ParticlesPerStep]);
		spart__submit_particles(partSystem, partEmitter, partType, partNum, uniformIndex);
	}

	//Reset GPU settings
	shader_reset();
	gpu_set_state(gpu_state);
	ds_map_destroy(gpu_state);


}
