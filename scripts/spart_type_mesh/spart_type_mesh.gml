/// @description spart_type_mesh(partType, modelBuffer, numPerBatch)
/// @param partType
/// @param model
/// @param numPerBatch (max 255)
function spart_type_mesh(argument0, argument1, argument2) {
	/*
		Lets you draw 3D meshes as particles. The meshes will be simulated in the same way as the billboarded particles, 
		but will be drawn in full 3D and not in view-space.
		Model can be an index of a buffer, a path to an .obj model or a path to a buffer.
		If a buffer is supplied, it must be formatted in the following way:
			3D position,		3x4 bytes
			Normal				3x4 bytes
			Texture coordinates	2x4 bytes
			Colour				4x1 bytes
		NumPerBatch cannot exceed 255!

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var mbuff, normalxyAngle, normalzAngle;
	var partType = argument0;

	if partType[| sPartTyp.MeshEnabled]
	{	//If a mesh vbuff exists, delete it
		vertex_delete_buffer(partType[| sPartTyp.MeshVbuff]);
	}
	partType[| sPartTyp.MeshEnabled] = true;

	//If the argument is a string, assume the user is trying to load an external file
	if is_string(argument1)
	{
		if string_upper(filename_ext(argument1)) == ".OBJ"
		{
			mbuff = spart__load_obj_to_buffer(argument1);
		}
		else
		{
			mbuff = buffer_load(argument1);
		}
	}
	else
	{
		mbuff = argument1;
	}

	partType[| sPartTyp.MeshNumPerBatch] = clamp(argument2, 0, 255);
	var bytesPerVert = 3 * 4 + 3 * 4 + 2 * 4 + 4 * 1;
	var vertNum = buffer_get_size(mbuff) / bytesPerVert;
	partType[| sPartTyp.MeshMbuff] = buffer_create(8 * vertNum * partType[| sPartTyp.MeshNumPerBatch], buffer_fixed, 1);
	var partMbuff = partType[| sPartTyp.MeshMbuff];

	//Find the outer boundaries of the vertex buffer
	var Min = [9999999, 9999999, 9999999];
	var Max = [-9999999, -9999999, -9999999];
	for (var i = 0; i < vertNum; i ++)
	{
		buffer_seek(mbuff, buffer_seek_start, i * bytesPerVert);
		for (var j = 0; j < 3; j ++)
		{
			var v = buffer_read(mbuff, buffer_f32);
			Min[j] = min(Min[j], v);
			Max[j] = max(Max[j], v);
		}
	}
	var size = max(Max[0] - Min[0], Max[1] - Min[1], Max[2] - Min[2]);
	var offsetx = (Min[0] + Max[0]) / 2;
	var offsety = (Min[1] + Max[1]) / 2;
	var offsetz = (Min[2] + Max[2]) / 2;
	buffer_seek(mbuff, buffer_seek_start, 0);
	for (var i = 0; i < vertNum; i ++)
	{
		//Read vertex info
		buffer_seek(mbuff, buffer_seek_start, i * bytesPerVert);
		var vx = buffer_read(mbuff, buffer_f32);
		var vy = buffer_read(mbuff, buffer_f32);
		var vz = buffer_read(mbuff, buffer_f32);
		var nx = buffer_read(mbuff, buffer_f32);
		var ny = buffer_read(mbuff, buffer_f32);
		var nz = buffer_read(mbuff, buffer_f32);
		var tu = buffer_read(mbuff, buffer_f32);
		var tv = buffer_read(mbuff, buffer_f32);
	
		//Encode vertex info
		vx = 255 * (0.5 + (vx - offsetx) / size);
		vy = 255 * (0.5 + (vy - offsety) / size);
		vz = 255 * (0.5 + (vz - offsetz) / size);
		tu = clamp(round(tu * 255), 0, 255);
		tv = clamp(round(tv * 255), 0, 255);
		normalxyAngle = floor(255 * point_direction(0, 0, nx, ny) / 360);
		normalzAngle = floor(255 * point_direction(0, 0, nz, -point_distance(0, 0, nx, ny)) / 180);
	
		//Write vertex info multiple times to the target buffer
		for (var j = 0; j < partType[| sPartTyp.MeshNumPerBatch]; j ++)
		{
			buffer_seek(partMbuff, buffer_seek_start, (i + j * vertNum) * 8);
		
			//Vertex position
			buffer_write(partMbuff, buffer_u8, vx);
			buffer_write(partMbuff, buffer_u8, vy);
			buffer_write(partMbuff, buffer_u8, vz);
		
			//Particle index
			buffer_write(partMbuff, buffer_u8, j);
		
			//Texture coords
			buffer_write(partMbuff, buffer_u8, tu);
			buffer_write(partMbuff, buffer_u8, tv);
		
			//Encode normals into two bytes
			buffer_write(partMbuff, buffer_u8, normalxyAngle);
			buffer_write(partMbuff, buffer_u8, normalzAngle);
		}
	}

	partType[| sPartTyp.MeshVbuff] = vertex_create_buffer_from_buffer(partMbuff, sPartMeshFormat);
	vertex_freeze(partType[| sPartTyp.MeshVbuff]);


	//If a new buffer was created in this script, delete the buffer
	if is_string(argument1)
	{
		buffer_delete(mbuff);
	}


}
