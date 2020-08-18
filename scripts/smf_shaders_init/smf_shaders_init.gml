function smf_shaders_init() {
	enum SMF_uni{SpecReflectance,SpecDamping,CelSteps,RimPower,RimFactor,NormalMapFactor,HeightMapMinSamples,HeightMapMaxSamples,HeightMapScale,Animate,Sample,Lights,LightNum,AmbientColor,NormalMap,TexScale,NomScale,RefScale,OutlineThickness,OutlineColour,ReflectionMap,ReflectionFactor,ShadowNear,ShadowFar,TexelSize,ShadowSmoothing,ShadowCascade,ShadowDepthBias1,ShadowSampler1,ShadowIntensity1,ShadowClippingPlanes1,ShadowTexelSize1,ShadowVPMatrix1,ShadowPos1,ShadowDepthBias2,ShadowSampler2,ShadowIntensity2,ShadowClippingPlanes2,ShadowTexelSize2,ShadowVPMatrix2,ShadowPos2,HeightMap,TexUVs,NomUVs,RefUVs,HmUVs,CamPos}
	globalvar SMF_uniforms, SMF_shader_compiled;
	SMF_uniforms = ds_map_create();
	SMF_shader_compiled = ds_map_create();

	SMF_shader_compiled[? sh_smf_basic] = smf_shader_update_uniforms(sh_smf_basic);
	SMF_shader_compiled[? sh_smf_v] = smf_shader_update_uniforms(sh_smf_v);
	SMF_shader_compiled[? sh_smf_v_outline] = smf_shader_update_uniforms(sh_smf_v_outline);
	SMF_shader_compiled[? sh_smf_v_reflection] = smf_shader_update_uniforms(sh_smf_v_reflection);
	SMF_shader_compiled[? sh_smf_v_outline_reflection] = smf_shader_update_uniforms(sh_smf_v_outline_reflection);
	SMF_shader_compiled[? sh_smf_v_shadow] = smf_shader_update_uniforms(sh_smf_v_shadow);
	SMF_shader_compiled[? sh_smf_f] = smf_shader_update_uniforms(sh_smf_f);
	SMF_shader_compiled[? sh_smf_f_norm] = smf_shader_update_uniforms(sh_smf_f_norm);
	SMF_shader_compiled[? sh_smf_f_norm_height] = smf_shader_update_uniforms(sh_smf_f_norm_height);
	SMF_shader_compiled[? sh_smf_f_shadow] = smf_shader_update_uniforms(sh_smf_f_shadow);
	SMF_shader_compiled[? sh_smf_f_reflection] = smf_shader_update_uniforms(sh_smf_f_reflection);
	SMF_shader_compiled[? sh_smf_f_norm_reflection] = smf_shader_update_uniforms(sh_smf_f_norm_reflection);
	SMF_shader_compiled[? sh_smf_f_norm_height_reflection] = smf_shader_update_uniforms(sh_smf_f_norm_height_reflection);
	SMF_shader_compiled[? sh_smf_shadowmap] = smf_shader_update_uniforms(sh_smf_shadowmap);


}
