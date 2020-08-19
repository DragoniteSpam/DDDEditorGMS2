/// @description smf_shadowmap_update_draw_model(modelIndex, [sample])
/// @param modelIndex
/// @param [sample]
function smf_shadowmap_update_draw_model() {
	var tex, texX, texY, texW, texH, nom, nomX, nomY, nomW, nomH, mat, modelIndex, Visible, matArray, modArray, matInd, texInd, nomInd, compiled, animate, sample, m, shader, cullmode, uni, ref, refX, refY, refW, refH, clampTexCoords, Static;
	modelIndex = argument[0];
	modArray = modelIndex[| SMF_model.VBuff];
	Visible = modelIndex[| SMF_model.Visible];
	Static = modelIndex[| SMF_model.Static];
	animate = false;
	uni = SMF_uniforms[? sh_smf_shadowmap];

	if argument_count > 1 and !Static
	{
	    sample = argument[1];
	    animate = true;
	    shader_set_uniform_f_array(uni[SMF_uni.Sample], sample);
	}
	shader_set_uniform_i(uni[SMF_uni.Animate], animate);
	for (m = 0; m < array_length(modArray); m ++)
	{
	    if !Visible[m]{continue;}
	    vertex_submit(modArray[m], pr_trianglelist, -1);
	}


}
