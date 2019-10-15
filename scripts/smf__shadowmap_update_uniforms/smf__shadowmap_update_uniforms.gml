/// @description smf__shadowmap_update_uniforms(shaderEnum)
/// @param shaderEnum

if array_length_1d(SMF_shadowmapEnabled) < 1{exit;}

/////////////////////////////////////
//Set uniforms
var uni = SMF_uniforms[? argument0];
shader_set_uniform_i(uni[SMF_uni.ShadowSmoothing], SMF_shadowmapSmoothing);
shader_set_uniform_i(uni[SMF_uni.ShadowCascade], 0);

shadowmap = SMF_shadowmapEnabled[0];
shader_set_uniform_f(uni[SMF_uni.ShadowDepthBias1], shadowmap[| SMF_shadowmap.depthbias]);
texture_set_stage(uni[SMF_uni.ShadowSampler1], surface_get_texture(shadowmap[| SMF_shadowmap.surface]));
shader_set_uniform_f(uni[SMF_uni.ShadowIntensity1], shadowmap[| SMF_shadowmap.intensity]);
shader_set_uniform_f(uni[SMF_uni.ShadowClippingPlanes1], shadowmap[| SMF_shadowmap.near], shadowmap[| SMF_shadowmap.far]);
shader_set_uniform_f(uni[SMF_uni.ShadowTexelSize1], shadowmap[| SMF_shadowmap.texelsize]);
shader_set_uniform_f_array(uni[SMF_uni.ShadowVPMatrix1], shadowmap[| SMF_shadowmap.vpmat]);
shader_set_uniform_f_array(uni[SMF_uni.ShadowPos1], shadowmap[| SMF_shadowmap.pos]);

if array_length_1d(SMF_shadowmapEnabled) > 1
{
	shader_set_uniform_i(uni[SMF_uni.ShadowCascade], 1);
	shadowmap = SMF_shadowmapEnabled[1];
	shader_set_uniform_f(uni[SMF_uni.ShadowDepthBias2], shadowmap[| SMF_shadowmap.depthbias]);
	texture_set_stage(uni[SMF_uni.ShadowSampler2], surface_get_texture(shadowmap[| SMF_shadowmap.surface]));
	shader_set_uniform_f(uni[SMF_uni.ShadowIntensity2], shadowmap[| SMF_shadowmap.intensity]);
	shader_set_uniform_f(uni[SMF_uni.ShadowClippingPlanes2], shadowmap[| SMF_shadowmap.near], shadowmap[| SMF_shadowmap.far]);
	shader_set_uniform_f(uni[SMF_uni.ShadowTexelSize2], shadowmap[| SMF_shadowmap.texelsize]);
	shader_set_uniform_f_array(uni[SMF_uni.ShadowVPMatrix2], shadowmap[| SMF_shadowmap.vpmat]);
	shader_set_uniform_f_array(uni[SMF_uni.ShadowPos2], shadowmap[| SMF_shadowmap.pos]);
}