/// @description smf_model_load_from_buffer(buffer, [name])
/// @param buffer
/// @param [name]
/*
Load an SMF model
Returns the index of the model

Script made by TheSnidr
www.TheSnidr.com
*/
var path, loadBuff, HeaderText, size, vertBuff, vBuff, n, vertList, modelName, texPos, matPos, modPos, nodPos, colPos, rigPos, aniPos, selPos, versionNum;
if is_string(argument[0]){
	show_debug_message("smf_model_load:\nTrying to load model " + string(argument[0]) + ", but you've supplied a string rather than a buffer.\nThe loading system has been changed to make it easier to load models asynchronously. \nPlease load the .smf file as a buffer, and supply this to the smf_model_load script!");
	return -1;}
modelName = string(argument[0]);
if argument_count > 1{modelName = string(argument[1]);}

show_debug_message("Attempting to load SMF model " + modelName);

loadBuff = argument[0];

//Check if the buffer has been compressed. If it has, decompress it
var compressed = false;
if os_browser == browser_not_a_browser
{
	var decompressedBuff = buffer_decompress(loadBuff);
	if decompressedBuff >= 0{
		loadBuff = decompressedBuff;
		compressed = true;}
}

//Check if the header text is correct
buffer_seek(loadBuff, buffer_seek_start, 0);
HeaderText = buffer_read(loadBuff, buffer_string);
if HeaderText != "SnidrsModelFormat"{
	show_message("File " + modelName + " is not a valid SMF file");
	if compressed{buffer_delete(loadBuff);}
	return -1;}

//Check if the version is supported
versionNum = buffer_read(loadBuff, buffer_f32);
if versionNum != 7{
	show_message("Error when loading SMF file " + string(modelName) + "\nAttempting to load version " + string(versionNum) + ". This importer only supports SMF version 7.");
	if compressed{buffer_delete(loadBuff);}
	return -1;}

//Load header
texPos = buffer_read(loadBuff, buffer_u32);
matPos = buffer_read(loadBuff, buffer_u32);
modPos = buffer_read(loadBuff, buffer_u32);
nodPos = buffer_read(loadBuff, buffer_u32);
colPos = buffer_read(loadBuff, buffer_u32);
rigPos = buffer_read(loadBuff, buffer_u32);
aniPos = buffer_read(loadBuff, buffer_u32);
selPos = buffer_read(loadBuff, buffer_u32);
buffer_read(loadBuff, buffer_u32); //Placeholder
buffer_read(loadBuff, buffer_u32); //Placeholder

var modelIndex = ds_list_create();
ds_list_add(SMF_modelList, modelIndex, modelName);

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Model name
modelIndex[| SMF_model.Name] = modelName;
modelIndex[| SMF_model.Kind] = pr_trianglelist;
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Load number of vertex buffers
var modelNum = buffer_read(loadBuff, buffer_u8);

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Load model size
var center = [0, 0, 0], size;
center[0] = buffer_read(loadBuff, buffer_f32);
center[1] = buffer_read(loadBuff, buffer_f32);
center[2] = buffer_read(loadBuff, buffer_f32);
size = buffer_read(loadBuff, buffer_f32);
modelIndex[| SMF_model.Center] = center;
modelIndex[| SMF_model.Size] = size;
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Load textures
buffer_seek(loadBuff, buffer_seek_start, texPos);
var n = buffer_read(loadBuff, buffer_u8);
var s = surface_create(1, 1);
var texBuff = buffer_create(1, buffer_fast, 1);
for (var t = 0; t < n; t ++)
{
	name = buffer_read(loadBuff, buffer_string);
	var w = buffer_read(loadBuff, buffer_u16);
	var h = buffer_read(loadBuff, buffer_u16);
	if ds_list_find_index(SMF_textureList, name) < 0 //If this sprite hasn't been added to the SMF system before
	{
		var spr = asset_get_index(name);
		if spr >= 0
		{ 
			//If the sprite already exists in the game files, use this instead of loading externally. This is the best way to load textures!
			smf_texture_add(spr, name, false);
		}
		else if w > 0 and h > 0
		{
			//If the texture is included in the .smf file, load it
			surface_resize(s, w, h);
			buffer_resize(texBuff, w * h * 4)
			buffer_copy(loadBuff, buffer_tell(loadBuff), w * h * 4, texBuff, 0);
			buffer_set_surface(texBuff, s, 0, 0, 0);
			smf_texture_add(sprite_create_from_surface(s, 0, 0, w, h, 0, 0, 0, 0), name, true);
		}
		else
		{
			//The sprite doesn't exist anywhere. Duplicate the default white texture instead.
			smf_texture_add(sprite_duplicate(SMF_textureList[| 0]), name, true);
		}
	}
	buffer_seek(loadBuff, buffer_seek_relative, w * h * 4)
}
surface_free(s);
buffer_delete(texBuff);
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//Load materials
buffer_seek(loadBuff, buffer_seek_start, matPos);
var materialNum = buffer_read(loadBuff, buffer_u8);
var material = ds_grid_create(materialNum, SMF_mat.MatParameters);
for (var mat = 0; mat < materialNum; mat ++){
	//Load info about the material
	material[# mat, SMF_mat.Name] = buffer_read(loadBuff, buffer_string);
	material[# mat, SMF_mat.Type] = buffer_read(loadBuff, buffer_u8);
	material[# mat, SMF_mat.Shader] = sh_smf_basic;
		
	if material[# mat, SMF_mat.Type] == 0{continue;}
			
	//Effect modifyers
	material[# mat, SMF_mat.SpecReflectance] = buffer_read(loadBuff, buffer_u8) / 127;
	material[# mat, SMF_mat.SpecDamping] = buffer_read(loadBuff, buffer_u8);
	material[# mat, SMF_mat.CelSteps] = buffer_read(loadBuff, buffer_u8);
	material[# mat, SMF_mat.RimPower] = buffer_read(loadBuff, buffer_u8);
	material[# mat, SMF_mat.RimFactor] = buffer_read(loadBuff, buffer_u8) / 127;
			
	//Normal map
	material[# mat, SMF_mat.NormalMapEnabled] = buffer_read(loadBuff, buffer_u8);
	if material[# mat, SMF_mat.NormalMapEnabled]{
		material[# mat, SMF_mat.NormalMap] = smf_texture_get_index(buffer_read(loadBuff, buffer_string));
		material[# mat, SMF_mat.NormalMapFactor] = buffer_read(loadBuff, buffer_u8) / 127 - 1;
		//Heightmap
		material[# mat, SMF_mat.HeightMapEnabled] = buffer_read(loadBuff, buffer_u8);
		if material[# mat, SMF_mat.HeightMapEnabled]{
			material[# mat, SMF_mat.HeightMapMinSamples] = buffer_read(loadBuff, buffer_u8);
			material[# mat, SMF_mat.HeightMapMaxSamples] = buffer_read(loadBuff, buffer_u8);
			material[# mat, SMF_mat.HeightMapScale] = buffer_read(loadBuff, buffer_u8) / 255;}}
	//Outlines
	material[# mat, SMF_mat.OutlinesEnabled] = buffer_read(loadBuff, buffer_u8);
	if material[# mat, SMF_mat.OutlinesEnabled]{
		material[# mat, SMF_mat.OutlineThickness] = buffer_read(loadBuff, buffer_u8) / 25;
		material[# mat, SMF_mat.OutlineRed] = buffer_read(loadBuff, buffer_u8) / 255;
		material[# mat, SMF_mat.OutlineGreen] = buffer_read(loadBuff, buffer_u8) / 255;
		material[# mat, SMF_mat.OutlineBlue] = buffer_read(loadBuff, buffer_u8) / 255;}
	//Reflection
	material[# mat, SMF_mat.ReflectionsEnabled] = buffer_read(loadBuff, buffer_u8);
	if material[# mat, SMF_mat.ReflectionsEnabled]{
		material[# mat, SMF_mat.ReflectionMap] = smf_texture_get_index(buffer_read(loadBuff, buffer_string));
		material[# mat, SMF_mat.ReflectionFactor] = buffer_read(loadBuff, buffer_u8) / 255;}
		
	//Decide which shader to use based on the loaded info
	if material[# mat, SMF_mat.Type] == 1{
		if material[# mat, SMF_mat.OutlinesEnabled]{
			if material[# mat, SMF_mat.ReflectionsEnabled]{material[# mat, SMF_mat.Shader] = sh_smf_v_outline_reflection;}
			else{material[# mat, SMF_mat.Shader] = sh_smf_v_outline;}}
		else if material[# mat, SMF_mat.ReflectionsEnabled]{material[# mat, SMF_mat.Shader] = sh_smf_v_reflection;}
		else{material[# mat, SMF_mat.Shader] = sh_smf_v;}}
	else if material[# mat, SMF_mat.Type] == 2{
		if material[# mat, SMF_mat.OutlinesEnabled]{
			if material[# mat, SMF_mat.ReflectionsEnabled]{material[# mat, SMF_mat.Shader] = sh_smf_f_outline_reflection;}
			else{material[# mat, SMF_mat.Shader] = sh_smf_f_outline;}}
		else if material[# mat, SMF_mat.ReflectionsEnabled]{
			if material[# mat, SMF_mat.NormalMapEnabled]{
				if material[# mat, SMF_mat.HeightMapEnabled]{material[# mat, SMF_mat.Shader] = sh_smf_f_norm_height_reflection;}
				else{material[# mat, SMF_mat.Shader] = sh_smf_f_norm_reflection;}}
			else{material[# mat, SMF_mat.Shader] = sh_smf_f_reflection;}}
		else if material[# mat, SMF_mat.NormalMapEnabled]{
				if material[# mat, SMF_mat.HeightMapEnabled]{material[# mat, SMF_mat.Shader] = sh_smf_f_norm_height;}
			else{material[# mat, SMF_mat.Shader] = sh_smf_f_norm}}
		else{material[# mat, SMF_mat.Shader] = sh_smf_f;}}
}
modelIndex[| SMF_model.Material] = material;
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//Load models
buffer_seek(loadBuff, buffer_seek_start, modPos);
var matInd = -1, matName;
var texInd = -1, texName;
var vBuff = -1;
var mBuff = -1;
var Visible = -1;
for (var m = 0; m < modelNum; m ++)
{		
	//Read vertex buffers
	size = buffer_read(loadBuff, buffer_u32);
	mBuff[m] = buffer_create(size, buffer_grow, 1);
	buffer_copy(loadBuff, buffer_tell(loadBuff), size, mBuff[m], 0);
	vBuff[m] = vertex_create_buffer_from_buffer(mBuff[m], SMF_format);
	vertex_freeze(vBuff[m]);
	buffer_delete(mBuff[m]); mBuff[m] = -1; //Delete the model buffer
	buffer_seek(loadBuff, buffer_seek_relative, size);
	//Read material and texture names
	matName = buffer_read(loadBuff, buffer_string);
	for (var mat = 0; mat < materialNum; mat ++)
	{
		if matName == material[# mat, SMF_mat.Name]
		{
			matInd[m] = mat;
			break;
		}
	}
	texName = buffer_read(loadBuff, buffer_string);
	texInd[m] = smf_texture_get_index(texName);
	//Read visible
	Visible[m] = buffer_read(loadBuff, buffer_u8);
	//Ignore skinning info
	var n = buffer_read(loadBuff, buffer_u32);
	repeat n{
		buffer_seek(loadBuff, buffer_seek_relative, buffer_read(loadBuff, buffer_u8) * 4);}
	var n = buffer_read(loadBuff, buffer_u32);
	buffer_seek(loadBuff, buffer_seek_relative, n * 4);
}
modelIndex[| SMF_model.VBuff] = vBuff;
modelIndex[| SMF_model.MBuff] = mBuff;
modelIndex[| SMF_model.Visible] = Visible; Visible = -1;
modelIndex[| SMF_model.MaterialIndex] = matInd;
modelIndex[| SMF_model.TextureIndex] = texInd;
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//Load nodes
buffer_seek(loadBuff, buffer_seek_start, nodPos);
var loadM, nodeTypeMap, nodeScale, nodeTypeScale, nodeTypeNum, nodeList, nodeNum, scale, type, lightList;
loadM = [0, 0, 0, 0, 0, 0, 0, 0, 0];
lightList = ds_list_create();
nodeTypeMap = ds_map_create();
nodeScale = ds_list_create();
nodeTypeNum = buffer_read(loadBuff, buffer_u8);
for (var i = 0; i < nodeTypeNum; i += 4){
	name = buffer_read(loadBuff, buffer_string);
	ds_map_add(nodeTypeMap, i, name);
	buffer_read(loadBuff, buffer_string);
	nodeScale[| i] = buffer_read(loadBuff, buffer_f32);}
nodeList = ds_list_create();
nodeNum = buffer_read(loadBuff, buffer_u8);
repeat nodeNum{
	type = buffer_read(loadBuff, buffer_u8);
	ds_list_add(nodeList, type);
	for (var j = 0; j < 9; j ++){
		loadM[j] = buffer_read(loadBuff, buffer_f32);}
	var oMat = smf_matrix_create(loadM[0], loadM[1], loadM[2], [loadM[3], loadM[4], loadM[5]], [loadM[6], loadM[7], loadM[8]]);
	ds_list_add(nodeList, oMat)
	var lightType = buffer_read(loadBuff, buffer_u8);
	var light = [0, 0, 0, 0, 0, 0, 0, 0];
	if lightType != 0
	{
		var i = 0;
		light[i++] = buffer_read(loadBuff, buffer_f32);
		light[i++] = buffer_read(loadBuff, buffer_f32);
		light[i++] = buffer_read(loadBuff, buffer_f32);
		light[i++] = buffer_read(loadBuff, buffer_f32);
		light[i++] = buffer_read(loadBuff, buffer_f32);
		light[i++] = buffer_read(loadBuff, buffer_f32);
		light[i++] = buffer_read(loadBuff, buffer_f32);
		light[i++] = buffer_read(loadBuff, buffer_f32);
		ds_list_add(lightList, ds_list_size(nodeList));
	}
	ds_list_add(nodeList, light);
		
	//Load properties
	var propertyList = ds_list_create();
	ds_list_add(nodeList, propertyList);

	var propertyNum = buffer_read(loadBuff, buffer_u8);
	repeat propertyNum
	{
		var property = buffer_read(loadBuff, buffer_u8);
		ds_list_add(propertyList, property);
		switch property
		{
			case 0:
				ds_list_add(propertyList, buffer_read(loadBuff, buffer_f32)); 
				break;
			case 1:
				ds_list_add(propertyList, buffer_read(loadBuff, buffer_string)); 
				break;
			case 2:
				var closed = buffer_read(loadBuff, buffer_u8);
				var smooth = buffer_read(loadBuff, buffer_u8);
				var steps  = buffer_read(loadBuff, buffer_u8);
				var pth = smf_path_create(closed);
				ds_list_add(propertyList, pth);
				//Skip the control points
				var num = buffer_read(loadBuff, buffer_u8);
				buffer_seek(loadBuff, buffer_seek_relative, num * 4 * 9);
				//Load the linearized path
				var num = buffer_read(loadBuff, buffer_u8);
				for (var i = 0; i < num; i ++)
				{
					var loadM;
					loadM = [0, 0, 0, 0, 0, 0, 0, 0, 0];
					for (var j = 0; j < 9; j ++){
						loadM[j] = buffer_read(loadBuff, buffer_f32);}
					smf_path_add_point(pth, smf_matrix_create(loadM[0], loadM[1], loadM[2], [loadM[3], loadM[4], loadM[5]], [loadM[6], loadM[7], loadM[8]]));
				}
				break;
		}
	}
}
//Ambient color
var amCol;
amCol[0] = buffer_read(loadBuff, buffer_u8) / 255;
amCol[1] = buffer_read(loadBuff, buffer_u8) / 255;
amCol[2] = buffer_read(loadBuff, buffer_u8) / 255;
//Save to model list
modelIndex[| SMF_model.NodeTypeMap] = nodeTypeMap;
modelIndex[| SMF_model.NodeScale] = nodeScale;
modelIndex[| SMF_model.NodeList] = nodeList;
modelIndex[| SMF_model.LightList] = lightList;
modelIndex[| SMF_model.AmbientColor] = amCol;
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//Load collision buffer
buffer_seek(loadBuff, buffer_seek_start, colPos);
var colList = -1;
var octList = -1;
var octBuffSize = 0;
var colBuffSize = buffer_read(loadBuff, buffer_u32);
var colBuff = -1;
var octBuff = -1;
if colBuffSize > 0{
	colBuff = buffer_create(colBuffSize, buffer_fixed, 4);
	buffer_copy(loadBuff, buffer_tell(loadBuff), colBuffSize, colBuff, 0);
	buffer_seek(loadBuff, buffer_seek_relative, colBuffSize);
		
	octBuffSize = buffer_read(loadBuff, buffer_u32);
	octBuff = buffer_create(octBuffSize, buffer_fixed, 4);
	buffer_copy(loadBuff, buffer_tell(loadBuff), octBuffSize, octBuff, 0);
	buffer_seek(loadBuff, buffer_seek_relative, octBuffSize);
}
modelIndex[| SMF_model.CollisionBuffer] = colBuff;
modelIndex[| SMF_model.OctreeBuffer] = octBuff;
modelIndex[| SMF_model.CollisionList] = colList;
modelIndex[| SMF_model.OctreeList] = octList;
modelIndex[| SMF_model.QuadtreeBuffer] = -1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Load rig
buffer_seek(loadBuff, buffer_seek_start, rigPos);
var boneNum, i, Q;
boneNum = buffer_read(loadBuff, buffer_u8);
bindPose = -1;
bindSampleMappingList = -1;
if boneNum > 0{
	var bonesInSample = 0;
	var bindPose = ds_list_create();
	var bindSampleMappingList = ds_list_create();
	for (i = 0; i < boneNum; i ++){
		Q = -1;
		for (var k = 0; k < 8; k ++){Q[k] = buffer_read(loadBuff, buffer_f32);} //The first 8 indices store the dual quaternion
		Q[8] = buffer_read(loadBuff, buffer_u8); //The 8th index stores the bone's parent
		Q[9] = buffer_read(loadBuff, buffer_u8); //The 9th index stores whether or not the bone is attached to its parent
		bindPose[| i] = Q;
		bindSampleMappingList[| i] = bonesInSample;
		if Q[9]{bonesInSample++;}}}
modelIndex[| SMF_model.BindPose] = bindPose;
modelIndex[| SMF_model.BindSampleMappingList] = bindSampleMappingList;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Load animation
buffer_seek(loadBuff, buffer_seek_start, aniPos);
var animationList = ds_list_create();
var animationNum = buffer_read(loadBuff, buffer_u8);
for (var a = 0; a < animationNum; a ++){
	var name = buffer_read(loadBuff, buffer_string);
	var frameNum = buffer_read(loadBuff, buffer_u8);
	var frameGrid = ds_grid_create(frameNum, boneNum + 1);
	ds_list_add(animationList, name, frameGrid, false);
	for (var f = 0; f < frameNum; f ++){
		frameGrid[# f, 0] = buffer_read(loadBuff, buffer_f32);
		for (var i = 0; i < boneNum; i ++){
			Q = -1;
			//Load the local delta dual quaternion of the frame
			for (var k = 0; k < 8; k ++){Q[k] = buffer_read(loadBuff, buffer_f32);}
			frameGrid[# f, i + 1] = Q;}}}
modelIndex[| SMF_model.Animation] = animationList;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Skip saved selections
buffer_seek(loadBuff, buffer_seek_start, selPos);
var selNum = buffer_read(loadBuff, buffer_u8);
repeat selNum{
	buffer_read(loadBuff, buffer_string);
	repeat modelNum{
		var n = buffer_read(loadBuff, buffer_u32);
		repeat n buffer_read(loadBuff, buffer_u32);}}

show_debug_message("Successfully loaded SMF model " + modelName);

if compressed
{
	buffer_delete(loadBuff);
}

return modelIndex;