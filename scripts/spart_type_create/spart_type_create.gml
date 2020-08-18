/// @description spart_type_create(partSystem)
/// @param partSystem
function spart_type_create(argument0) {
	/*
		Creates a new blank particle type.
		You can define the rules for this particular particle type with the
		spart_type scripts.

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var partType = ds_list_create();
	partType[| sPartTyp.Spr] = -1;
	partType[| sPartTyp.SprOrig] = [0, 0];
	partType[| sPartTyp.SprStretchRandomNum] = 0;
	partType[| sPartTyp.SprAnimSpd] = 0;
	partType[| sPartTyp.Size] = [32, 32, 0, 0]; //[min, max, incr, acc]
	partType[| sPartTyp.Speed] = [0, 0, 0, 0]; //[min, max, acc, jerk]
	partType[| sPartTyp.Dir] = [0, 0, 1, 0]; //[x, y, z, vary]
	partType[| sPartTyp.DirRadial] = false;
	partType[| sPartTyp.GravDir] = [0, 0, 0];
	partType[| sPartTyp.LifeMin] = 1;
	partType[| sPartTyp.LifeMax] = 1;
	partType[| sPartTyp.Angle] = [0, 0, 0, 0]; //[min, max, incr, acc]
	partType[| sPartTyp.AngleRel] = false;
	partType[| sPartTyp.Colour] = array_create(16, 1); //<-- An array containing four colours and four alphas
	partType[| sPartTyp.ColourType] = 1;
	partType[| sPartTyp.BlendSrc] = bm_src_alpha;
	partType[| sPartTyp.BlendDst] = bm_inv_src_alpha;
	partType[| sPartTyp.BlendEnable] = true;
	partType[| sPartTyp.AlphaTestRef] = 1;
	partType[| sPartTyp.Zwrite] = true;
	partType[| sPartTyp.StepNumber] = 0;
	partType[| sPartTyp.StepType] = -1;
	partType[| sPartTyp.DeathNumber] = 0;
	partType[| sPartTyp.DeathType] = -1;
	partType[| sPartTyp.MeshEnabled] = false;
	partType[| sPartTyp.MeshVbuff] = -1;
	partType[| sPartTyp.MeshRotAxis] = [0, 0, 1];
	partType[| sPartTyp.MeshAmbientCol] = [1, 1, 1];
	partType[| sPartTyp.MeshLightCol] = [0, 0, 0];
	partType[| sPartTyp.MeshLightDir] = [0, 0, -1];
	partType[| sPartTyp.CullMode] = cull_counterclockwise;

	var partSystem = argument0;
	ds_list_add(partSystem[| sPartSys.TypeList], partType);

	return partType;


}
