function smf_shader_update_uniforms(argument0) {
	var uni, shader;
	shader = argument0;
	uni = -1;
	if !shader_is_compiled(shader)
	{
	    return false;
	}
	switch shader
	{
	    case sh_smf_basic:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        break;

	    case sh_smf_v:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        break;
    
	    case sh_smf_v_outline:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        uni[SMF_uni.OutlineThickness] = shader_get_uniform(shader, "outlineThickness");
	        uni[SMF_uni.OutlineColour] = shader_get_uniform(shader, "outlineColour");
	        break;

	    case sh_smf_v_reflection:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.RefUVs] = shader_get_uniform(shader, "refUVs");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        uni[SMF_uni.ReflectionMap] = shader_get_sampler_index(shader, "reflectionSampler");
	        uni[SMF_uni.ReflectionFactor] = shader_get_uniform(shader, "reflectionFactor");
	        break;

	    case sh_smf_v_outline_reflection:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.RefUVs] = shader_get_uniform(shader, "refUVs");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        uni[SMF_uni.OutlineThickness] = shader_get_uniform(shader, "outlineThickness");
	        uni[SMF_uni.OutlineColour] = shader_get_uniform(shader, "outlineColour");
	        uni[SMF_uni.ReflectionMap] = shader_get_sampler_index(shader, "reflectionSampler");
	        uni[SMF_uni.ReflectionFactor] = shader_get_uniform(shader, "reflectionFactor");
	        break;

	    case sh_smf_v_shadow:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");

	        uni[SMF_uni.ShadowSmoothing] = shader_get_uniform(shader, "shadowSmoothing");
	        uni[SMF_uni.ShadowCascade] = shader_get_uniform(shader, "shadowEnableCascade");
	        uni[SMF_uni.ShadowDepthBias1] = shader_get_uniform(shader, "shadowDepthBias1");
	        uni[SMF_uni.ShadowSampler1] = shader_get_sampler_index(shader, "shadowMap1");
	        uni[SMF_uni.ShadowIntensity1] = shader_get_uniform(shader, "shadowIntensity1");
	        uni[SMF_uni.ShadowClippingPlanes1] = shader_get_uniform(shader, "shadowClippingPlanes1");
	        uni[SMF_uni.ShadowTexelSize1] = shader_get_uniform(shader, "shadowTexelSize1");
	        uni[SMF_uni.ShadowVPMatrix1] = shader_get_uniform(shader, "shadowVPMatrix1");
	        uni[SMF_uni.ShadowPos1] = shader_get_uniform(shader, "shadowPos1");
	        uni[SMF_uni.ShadowDepthBias2] = shader_get_uniform(shader, "shadowDepthBias2");
	        uni[SMF_uni.ShadowSampler2] = shader_get_sampler_index(shader, "shadowMap2");
	        uni[SMF_uni.ShadowIntensity2] = shader_get_uniform(shader, "shadowIntensity2");
	        uni[SMF_uni.ShadowClippingPlanes2] = shader_get_uniform(shader, "shadowClippingPlanes2");
	        uni[SMF_uni.ShadowTexelSize2] = shader_get_uniform(shader, "shadowTexelSize2");
	        uni[SMF_uni.ShadowVPMatrix2] = shader_get_uniform(shader, "shadowVPMatrix2");
	        uni[SMF_uni.ShadowPos2] = shader_get_uniform(shader, "shadowPos2");
	        break;

	    case sh_smf_f:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        break;

	    case sh_smf_f_norm:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.NomUVs] = shader_get_uniform(shader, "nomUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        uni[SMF_uni.NormalMap] = shader_get_sampler_index(shader, "normalMapSampler");
	        uni[SMF_uni.NormalMapFactor] = shader_get_uniform(shader, "normalMapFactor");
	        break;

	    case sh_smf_f_norm_height:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.NomUVs] = shader_get_uniform(shader, "nomUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        uni[SMF_uni.NormalMap] = shader_get_sampler_index(shader, "normalMapSampler");
	        uni[SMF_uni.NormalMapFactor] = shader_get_uniform(shader, "normalMapFactor");
	        uni[SMF_uni.HeightMap] = shader_get_sampler_index(shader, "heightMapSampler");
	        uni[SMF_uni.HeightMapScale] = shader_get_uniform(shader, "heightMapScale");
	        uni[SMF_uni.HeightMapMinSamples] = shader_get_uniform(shader, "minSamples");
	        uni[SMF_uni.HeightMapMaxSamples] = shader_get_uniform(shader, "maxSamples");
	        break;

	    case sh_smf_f_shadow:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");

	        uni[SMF_uni.ShadowSmoothing] = shader_get_uniform(shader, "shadowSmoothing");
	        uni[SMF_uni.ShadowCascade] = shader_get_uniform(shader, "shadowEnableCascade");
	        uni[SMF_uni.ShadowDepthBias1] = shader_get_uniform(shader, "shadowDepthBias1");
	        uni[SMF_uni.ShadowSampler1] = shader_get_sampler_index(shader, "shadowMap1");
	        uni[SMF_uni.ShadowIntensity1] = shader_get_uniform(shader, "shadowIntensity1");
	        uni[SMF_uni.ShadowClippingPlanes1] = shader_get_uniform(shader, "shadowClippingPlanes1");
	        uni[SMF_uni.ShadowTexelSize1] = shader_get_uniform(shader, "shadowTexelSize1");
	        uni[SMF_uni.ShadowVPMatrix1] = shader_get_uniform(shader, "shadowVPMatrix1");
	        uni[SMF_uni.ShadowPos1] = shader_get_uniform(shader, "shadowPos1");
	        uni[SMF_uni.ShadowDepthBias2] = shader_get_uniform(shader, "shadowDepthBias2");
	        uni[SMF_uni.ShadowSampler2] = shader_get_sampler_index(shader, "shadowMap2");
	        uni[SMF_uni.ShadowIntensity2] = shader_get_uniform(shader, "shadowIntensity2");
	        uni[SMF_uni.ShadowClippingPlanes2] = shader_get_uniform(shader, "shadowClippingPlanes2");
	        uni[SMF_uni.ShadowTexelSize2] = shader_get_uniform(shader, "shadowTexelSize2");
	        uni[SMF_uni.ShadowVPMatrix2] = shader_get_uniform(shader, "shadowVPMatrix2");
	        uni[SMF_uni.ShadowPos2] = shader_get_uniform(shader, "shadowPos2");
	        break;
    
	    case sh_smf_f_reflection:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.RefUVs] = shader_get_uniform(shader, "refUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        uni[SMF_uni.ReflectionMap] = shader_get_sampler_index(shader, "reflectionSampler");
	        uni[SMF_uni.ReflectionFactor] = shader_get_uniform(shader, "reflectionFactor");
	        break;

	    case sh_smf_f_norm_reflection:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.NomUVs] = shader_get_uniform(shader, "nomUVs");
	        uni[SMF_uni.RefUVs] = shader_get_uniform(shader, "refUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        uni[SMF_uni.NormalMap] = shader_get_sampler_index(shader, "normalMapSampler");
	        uni[SMF_uni.NormalMapFactor] = shader_get_uniform(shader, "normalMapFactor");
	        uni[SMF_uni.ReflectionMap] = shader_get_sampler_index(shader, "reflectionSampler");
	        uni[SMF_uni.ReflectionFactor] = shader_get_uniform(shader, "reflectionFactor");
	        break;

	    case sh_smf_f_norm_height_reflection:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.TexUVs] = shader_get_uniform(shader, "texUVs");
	        uni[SMF_uni.NomUVs] = shader_get_uniform(shader, "nomUVs");
	        uni[SMF_uni.RefUVs] = shader_get_uniform(shader, "refUVs");
	        uni[SMF_uni.CamPos] = shader_get_uniform(shader, "camPos");
	        uni[SMF_uni.Lights] = shader_get_uniform(shader, "lightArray");
	        uni[SMF_uni.LightNum] = shader_get_uniform(shader, "lightNum");
	        uni[SMF_uni.AmbientColor] = shader_get_uniform(shader, "ambientColor");
	        uni[SMF_uni.SpecReflectance] = shader_get_uniform(shader, "reflectivity");
	        uni[SMF_uni.SpecDamping] = shader_get_uniform(shader, "damping");
	        uni[SMF_uni.CelSteps] = shader_get_uniform(shader, "celSteps");
	        uni[SMF_uni.RimPower] = shader_get_uniform(shader, "rimPower");
	        uni[SMF_uni.RimFactor] = shader_get_uniform(shader, "rimFactor");
	        uni[SMF_uni.NormalMap] = shader_get_sampler_index(shader, "normalMapSampler");
	        uni[SMF_uni.NormalMapFactor] = shader_get_uniform(shader, "normalMapFactor");
	        uni[SMF_uni.ReflectionMap] = shader_get_sampler_index(shader, "reflectionSampler");
	        uni[SMF_uni.ReflectionFactor] = shader_get_uniform(shader, "reflectionFactor");
	        uni[SMF_uni.HeightMap] = shader_get_sampler_index(shader, "heightMapSampler");
	        uni[SMF_uni.HeightMapScale] = shader_get_uniform(shader, "heightMapScale");
	        uni[SMF_uni.HeightMapMinSamples] = shader_get_uniform(shader, "minSamples");
	        uni[SMF_uni.HeightMapMaxSamples] = shader_get_uniform(shader, "maxSamples");
	        break;

	    case sh_smf_shadowmap:
	        uni[SMF_uni.Animate] = shader_get_uniform(shader, "animate");
	        uni[SMF_uni.Sample] = shader_get_uniform(shader, "boneDQ");
	        uni[SMF_uni.ShadowNear] = shader_get_uniform(shader, "shadowNear");
	        uni[SMF_uni.ShadowFar] = shader_get_uniform(shader, "shadowFar");
	        uni[SMF_uni.TexelSize] = shader_get_uniform(shader, "texelSize");
	        break;
	}
	SMF_uniforms[? shader] = uni;
	return true;


}
