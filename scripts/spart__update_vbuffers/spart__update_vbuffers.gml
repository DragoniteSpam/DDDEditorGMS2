/// @description spart__update_vbuffers(partSystem);
/// @param partSystem
function spart__update_vbuffers(argument0) {
	/*
		Generates the vbuffs that the particle system needs
	
		Script created by TheSnidr
		www.TheSnidr.com
	*/
	var partSystem = argument0;
	var batchSizeArray = partSystem[| sPartSys.BatchSizeArray];
	var num = array_length_1d(batchSizeArray);
	var vertexBatchArray = array_create(num);
	var i, j, k, particlesPerBatch, mBuff, k;
	for (k = 0; k < num; k ++)
	{
		particlesPerBatch = batchSizeArray[k];
	
		//If this vertex buffer already exists, load the existing one
		if !is_undefined(sPartVertexBatchMap[? particlesPerBatch])
		{
			vertexBatchArray[k] = sPartVertexBatchMap[? particlesPerBatch];
			continue;
		}
		mBuff = buffer_create(particlesPerBatch * 24, buffer_fast, 1);
		for (i = 0; i < particlesPerBatch; i ++)
		{
			for (j = 2; j >= 0; j --)
			{
				buffer_write(mBuff, buffer_u8, i mod 256);
				buffer_write(mBuff, buffer_u8, (i div 256) mod 256);
				buffer_write(mBuff, buffer_u8, i div (256 * 256));
				buffer_write(mBuff, buffer_u8, j);
			}
			for (j = 1; j < 4; j ++)
			{
				buffer_write(mBuff, buffer_u8, i mod 256);
				buffer_write(mBuff, buffer_u8, (i div 256) mod 256);
				buffer_write(mBuff, buffer_u8, i div (256 * 256));
				buffer_write(mBuff, buffer_u8, j);
			}
		}
		vertexBatchArray[k] = vertex_create_buffer_from_buffer(mBuff, sPartFormat);
		vertex_freeze(vertexBatchArray[k]);
		buffer_delete(mBuff);
		sPartVertexBatchMap[? particlesPerBatch] = vertexBatchArray[k];
	}
	partSystem[| sPartSys.VertexBatchArray] = vertexBatchArray;


}
