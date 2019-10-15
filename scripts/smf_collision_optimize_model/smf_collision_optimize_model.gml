/// @description smf_collision_optimize_model(model)
/// @param modelIndex
/*
This scripts transforms the collision buffers into data structures
Data structures run faster, especially in HTML5 and on mobile devices, 
but takes a while to transform and requires more memory.
*/
var v;
var modelIndex = argument0;
var colBuff = modelIndex[| SMF_model.CollisionBuffer];
var octBuff = modelIndex[| SMF_model.OctreeBuffer];

//Convert from buffers to data structures
var colList, octList, triangleNum;
triangleNum = buffer_peek(octBuff, 7 * 4, buffer_f32);
colList = ds_list_create();
octList = ds_list_create();
for (var i = 0; i < triangleNum; i ++){
	v = array_create(12);
	for (var j = 0; j < 12; j ++){
		v[j] = buffer_read(colBuff, buffer_f32);
	}
	colList[| i] = v;
	v = -1;
}
var octBuffSize = buffer_get_size(octBuff);
for (var i = 0; i < octBuffSize / 4; i ++){
	octList[| i] = buffer_read(octBuff, buffer_f32);
}

modelIndex[| SMF_model.CollisionList] = colList;
modelIndex[| SMF_model.OctreeList] = octList;