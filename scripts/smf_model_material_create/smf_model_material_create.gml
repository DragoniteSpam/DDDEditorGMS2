/// @description smf_model_material_create()
var material = ds_grid_create(1, SMF_mat.MatParameters);
var mat = 0;

material[# mat, SMF_mat.ReflectionMap] = -1;
material[# mat, SMF_mat.Name] = "DefaultMaterial";
material[# mat, SMF_mat.Type] = 1; //Vertex shader
material[# mat, SMF_mat.Shader] = sh_smf_v;

//Effect modifyers
material[# mat, SMF_mat.SpecReflectance] = 0.2;
material[# mat, SMF_mat.SpecDamping] = 8;
material[# mat, SMF_mat.CelSteps] = 0;
material[# mat, SMF_mat.RimPower] = 0;
material[# mat, SMF_mat.RimFactor] = 0;

//Normal map
material[# mat, SMF_mat.NormalMapEnabled] = false;
material[# mat, SMF_mat.NormalMap] = smf_texture_get_index("NomDefault");
material[# mat, SMF_mat.NormalMapFactor] = 0;

//Heightmap
material[# mat, SMF_mat.HeightMapEnabled] = false;
material[# mat, SMF_mat.HeightMap] = smf_texture_get_index("TexDefault");
material[# mat, SMF_mat.HeightMapMinSamples] = 7;
material[# mat, SMF_mat.HeightMapMaxSamples] = 16;
material[# mat, SMF_mat.HeightMapScale] = 0;

//Outlines
material[# mat, SMF_mat.OutlinesEnabled] = false;
material[# mat, SMF_mat.OutlineThickness] = 0.2;
material[# mat, SMF_mat.OutlineRed] = 0;
material[# mat, SMF_mat.OutlineGreen] = 0;
material[# mat, SMF_mat.OutlineBlue] = 0;
	
//Reflection
material[# mat, SMF_mat.ReflectionsEnabled] = false;
material[# mat, SMF_mat.ReflectionMap] = smf_texture_get_index("TexDefault");
material[# mat, SMF_mat.ReflectionFactor] = 0;