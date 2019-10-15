/// @description smf_collision_create_buffer(modelIndex, bleedOver)
/// @param modelIndex
/// @param bleedOver
/*
THIS SHOULD NOT BE USED INGAME. ALWAYS PRECOMPILE YOUR COLLISION BUFFERS. THIS CAN EASILY BE DONE WITH THE SMF TOOL
Creates a collision buffer for the given model, so that collision checking can be performed later.
The model is split into an octree structure. Triangles that are outside a region, but not further away than bleedOver, are added to the region anyway

Script made by TheSnidr
www.TheSnidr.com
*/
var modelIndex = argument0;
var mBuff = modelIndex[| SMF_model.MBuff];
var quadBuff = modelIndex[| SMF_model.QuadtreeBuffer];
if modelIndex[| SMF_model.Kind] != pr_trianglelist{
	show_error("Error in script smf_collision_create_buffer: Can only create collision buffer from vertex buffers using pr_trianglelist", true);
	exit;}

var i, j, k, l, r, modelNum, vert, Min, Max, modelSize, regionTriList, levels, tempColBuff, tempModelBuffer, bufferSize, vertexNum, triangleNum, bleedOver, returnBuffer;
bleedOver = argument1;

/////////////////////////////
//---Find size of model---///
SMF__Min =  [99999, 99999, 99999];
SMF__Max = [-99999,-99999,-99999];
bufferSize = buffer_get_size(mBuff[0]);
for (i = 0; i < bufferSize; i += SMF_format_bytes){
	buffer_seek(mBuff[0], buffer_seek_start, i)
	for (j = 0; j < 3; j ++){
	    vert = buffer_read(mBuff[0], buffer_f32);
	    SMF__Min[j] = min(SMF__Min[j], vert);
	    SMF__Max[j] = max(SMF__Max[j], vert);}}
modelSize = max(SMF__Max[0] - SMF__Min[0], SMF__Max[1] - SMF__Min[1], SMF__Max[2] - SMF__Min[2]);
vertexNum = bufferSize div SMF_format_bytes;
triangleNum = vertexNum div 3;
if triangleNum == 0{exit;}

if quadBuff >= 0{buffer_delete(quadBuff);}
var colBuffHeader = 10*4;
quadBuff = buffer_create(colBuffHeader, buffer_grow, 4);
modelIndex[| SMF_model.QuadtreeBuffer] = quadBuff;

////////////////////////////////////////
//---Write collision buffer header---///
buffer_seek(quadBuff, buffer_seek_start, 0);
buffer_write(quadBuff, buffer_f32, colBuffHeader);	/*Position of subdivision part of buffer*/
buffer_write(quadBuff, buffer_f32, SMF__Min[0]);		/*Model x*/
buffer_write(quadBuff, buffer_f32, SMF__Min[1]);		/*Model y*/
buffer_write(quadBuff, buffer_f32, SMF__Min[2]);		/*Model z*/
buffer_write(quadBuff, buffer_f32, modelSize);	/*Model size*/
buffer_write(quadBuff, buffer_f32, bleedOver);	/*Bleed over*/
buffer_write(quadBuff, buffer_f32, 0);			/*Recursive depth of octree*/
buffer_write(quadBuff, buffer_f32, triangleNum);/*Number of triangles*/
repeat 2{buffer_write(quadBuff, buffer_f32, 0);} /*Placeholders in case more header information will be needed later*/

///////////////////////////////////////////////////////////////////
//---Subdivide the model recursively into an octree structure---///
regionTriList = ds_list_create();
for (var i = 0; i < triangleNum; i ++){regionTriList[| i] = i;}
globalvar SMF__quadBuff; SMF__quadBuff = quadBuff;
globalvar SMF__colBuff; SMF__colBuff = mBuff[0];
levels = smf__collision_recursive_split_quadtree(regionTriList, 0, 0, modelSize, bleedOver, 0);

//Write the recursive depth to collision buffer
buffer_poke(quadBuff, 6 * 4, buffer_f32, levels);

//If the octree is not split up at all, write the position of the octree in negative so that the parser knows this is a leaf region
if levels == 0
{
	buffer_poke(quadBuff, 0, buffer_f32, -colBuffHeader);	/*Position of subdivision part of buffer*/
}

//Clean up leftovers
ds_list_destroy(regionTriList);
