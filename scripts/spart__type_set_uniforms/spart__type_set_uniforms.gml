/// @description spart__type_set_uniforms(uniformIndex, partType);
/// @param uniformIndex
/// @param partType
function spart__type_set_uniforms(argument0, argument1) {
	/*
		Sets the uniforms for the given particle type
	
		Script created by TheSnidr
		www.TheSnidr.com
	*/
	var i = argument0;
	var partType = argument1;
	var g = sPartUniformGrid;
	shader_set_uniform_f(g[# sPartUni.partLife, i], partType[| sPartTyp.LifeMin], partType[| sPartTyp.LifeMax]);
	shader_set_uniform_f(g[# sPartUni.partSprAnimImgNum, i], partType[| sPartTyp.SprStretchRandomNum]);
	shader_set_uniform_f(g[# sPartUni.partSprAnimSpd, i], partType[| sPartTyp.SprAnimSpd]);
	shader_set_uniform_f_array(g[# sPartUni.partSprOrig, i], partType[| sPartTyp.SprOrig]);
	shader_set_uniform_f_array(g[# sPartUni.partGrav, i], partType[| sPartTyp.GravDir]);
	shader_set_uniform_f_array(g[# sPartUni.partAngle, i], partType[| sPartTyp.Angle]);
	shader_set_uniform_f_array(g[# sPartUni.partCol, i], partType[| sPartTyp.Colour]);
	shader_set_uniform_f_array(g[# sPartUni.partSize, i], partType[| sPartTyp.Size]);
	shader_set_uniform_f_array(g[# sPartUni.partSpd, i], partType[| sPartTyp.Speed]);
	shader_set_uniform_f_array(g[# sPartUni.partDir, i], partType[| sPartTyp.Dir]);
	shader_set_uniform_i(g[# sPartUni.partAngleRel, i], partType[| sPartTyp.AngleRel]);
	shader_set_uniform_i(g[# sPartUni.partDirRad, i], partType[| sPartTyp.DirRadial]);
	shader_set_uniform_f(g[# sPartUni.partColType, i], partType[| sPartTyp.ColourType]);
	shader_set_uniform_f(g[# sPartUni.partAlphaTestRef, i], partType[| sPartTyp.AlphaTestRef] / 255);

	if partType[| sPartTyp.MeshEnabled]
	{
		shader_set_uniform_f_array(g[# sPartUni.partMeshRotAxis, i], partType[| sPartTyp.MeshRotAxis]);
		shader_set_uniform_f_array(g[# sPartUni.partMeshAmbCol, i], partType[| sPartTyp.MeshAmbientCol]);
		shader_set_uniform_f_array(g[# sPartUni.partMeshLightCol, i], partType[| sPartTyp.MeshLightCol]);
		shader_set_uniform_f_array(g[# sPartUni.partMeshLightDir, i], partType[| sPartTyp.MeshLightDir]);
	}


}
