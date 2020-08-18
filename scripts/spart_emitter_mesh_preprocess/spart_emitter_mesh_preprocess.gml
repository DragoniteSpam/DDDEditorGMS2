/// @description spart_emitter_mesh_preprocess(obj, particleNum, hollow)
/// @param obj
/// @param particleNum
/// @param hollow
function spart_emitter_mesh_preprocess(argument0, argument1, argument2) {
	/*
		Preprocess the given mesh, creating all the possible particle positions within
		the mesh.
		Mesh can either be a buffer using the standard format, or the path to an OBJ file.
		Hollow mesh emitters are much faster to compute than non-hollow ones!

		Script created by TheSnidr
		www.thesnidr.com
	*/
	var mbuff = argument0;
	var partNum = argument1;
	var hollow = argument2;

	//If the argument is a string, assume the user is trying to load an external file
	if is_string(argument0)
	{
		if string_lower(filename_ext(argument0)) == ".obj"
		{
			mbuff = spart__load_obj_to_buffer(argument0);
		}
		else if string_lower(filename_ext(argument0)) == ".spartcache"
		{
			return spart_emitter_mesh_load(argument0);
		}
		else
		{
			show_debug_message("Error in script spart__emitter_mesh_preprocess: Could not load file " + string(argument0));
			exit;
		}
	}

	var bytesPerVert = 3 * 4 + 3 * 4 + 2 * 4 + 4 * 1;
	var vertNum = buffer_get_size(mbuff) / bytesPerVert;
	var meshBuff = buffer_create(8 * 6 * partNum, buffer_fixed, 1);

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
	var sizex = Max[0] - Min[0];
	var sizey = Max[1] - Min[1];
	var sizez = Max[2] - Min[2];
	var offsetx = (Min[0] + Max[0]) / 2;
	var offsety = (Min[1] + Max[1]) / 2;
	var offsetz = (Min[2] + Max[2]) / 2;
	var scale = 1 / max(sizex, sizey, sizez, math_get_epsilon());

	//Index the triangles
	var A = 0; //Total area
	var V = array_create(9);
	var triList = ds_list_create();
	buffer_seek(mbuff, buffer_seek_start, 0);
	for (var i = 0; i < vertNum; i += 3)
	{
		for (var j = 0; j < 3; j ++)
		{
			for (var k = 0; k < 3; k ++)
			{
				//Read vert position
			    V[j * 3 + k] = buffer_peek(mbuff, (i + j) * bytesPerVert + k * 4, buffer_f32);
			}
		}
		var tri = array_create(14);
		tri[0] = .5 + (V[0] - offsetx) * scale;
		tri[1] = .5 + (V[1] - offsety) * scale;
		tri[2] = .5 + (V[2] - offsetz) * scale;
		tri[3] = .5 + (V[3] - offsetx) * scale;
		tri[4] = .5 + (V[4] - offsety) * scale;
		tri[5] = .5 + (V[5] - offsetz) * scale;
		tri[6] = .5 + (V[6] - offsetx) * scale;
		tri[7] = .5 + (V[7] - offsety) * scale;
		tri[8] = .5 + (V[8] - offsetz) * scale;
		var ux = tri[3] - tri[0];
		var uy = tri[4] - tri[1];
		var uz = tri[5] - tri[2];
		var vx = tri[6] - tri[0];
		var vy = tri[7] - tri[1];
		var vz = tri[8] - tri[2];
		var Nx = uy * vz - uz * vy;
		var Ny = uz * vx - ux * vz;
		var Nz = ux * vy - uy * vx;
		var l = sqrt(sqr(Nx) + sqr(Ny) + sqr(Nz));
		if (l == 0){continue;}
		var d = 1 / l;
		tri[9]  = Nx * d;
		tri[10] = Ny * d;
		tri[11] = Nz * d;
		tri[12] = l; //The area of the triangle
		tri[13] = 0; //Number of particles in this triangle
		A += l;
	
		ds_list_add(triList, tri);
	}
	var triNum = ds_list_size(triList);
	var partID = 0;



	if hollow
	{
		var partIndList = ds_list_create();
		for (var i = 0; i < partNum; i ++){partIndList[| i] = i;}
		ds_list_shuffle(partIndList);
	
		//If the mesh is hollow, we only need to generate particles on the surface of the mesh's triangles!
		var areaPerParticle = A / partNum;
		var areaSinceLastParticle = 0;
		var num = 0;
		while (num < partNum)
		{
			var ind = irandom(ds_list_size(triList) - 1);
			tri = triList[| ind];
			areaSinceLastParticle += tri[12];
			while (areaSinceLastParticle >= areaPerParticle)
			{
				tri[@ 13] ++;
				if (tri[13] > ceil(tri[12] / areaPerParticle))
				{	//Delete the triangle from the list if it contains too many particles
					ds_list_delete(triList, ind);
					triNum --;
					break;
				}
				areaSinceLastParticle -= areaPerParticle;
				var w1 = random(1);
				var w2 = random(1);
				var w3 = random(1);
				var s = w1 + w2 + w3;
				if (s == 0){continue;}
				w1 /= s;
				w2 /= s;
				w3 /= s;
				var px = tri[0] * w1 + tri[3] * w2 + tri[6] * w3;
				var py = tri[1] * w1 + tri[4] * w2 + tri[7] * w3;
				var pz = tri[2] * w1 + tri[5] * w2 + tri[8] * w3;
			
				//Write the particle to the buffer
				var partInd = partIndList[| num];
				for (var j = 2; j >= 0; j --)
				{
					buffer_write(meshBuff, buffer_u8, partInd mod 256);
					buffer_write(meshBuff, buffer_u8, (partInd div 256) mod 256);
					buffer_write(meshBuff, buffer_u8, partInd div (256 * 256));
					buffer_write(meshBuff, buffer_u8, j); //Corner ID
			
					buffer_write(meshBuff, buffer_u8, floor(px * 255));
					buffer_write(meshBuff, buffer_u8, floor(py * 255));
					buffer_write(meshBuff, buffer_u8, floor(pz * 255));
					buffer_write(meshBuff, buffer_u8, 0); //Distance to nearest tri
				}
				for (var j = 1; j < 4; j ++)
				{
					buffer_write(meshBuff, buffer_u8, partInd mod 256);
					buffer_write(meshBuff, buffer_u8, (partInd div 256) mod 256);
					buffer_write(meshBuff, buffer_u8, partInd div (256 * 256));
					buffer_write(meshBuff, buffer_u8, j); //Corner ID
			
					buffer_write(meshBuff, buffer_u8, floor(px * 255));
					buffer_write(meshBuff, buffer_u8, floor(py * 255));
					buffer_write(meshBuff, buffer_u8, floor(pz * 255));
					buffer_write(meshBuff, buffer_u8, 0); //Distance to nearest tri
				}
				num ++;
				if (num >= partNum){break;}
			}
		}
	}
	else
	{
		//Subdivide the model to make particle generation easier
		var divNum = floor(2 * power(triNum, 1/3));
		var subdiv = ds_grid_create(divNum, divNum * divNum);
		ds_grid_clear(subdiv, -1);
		for (var i = 0; i < triNum; i ++)
		{
			var tri = triList[| i];
			var rSize = 1 / divNum;
			var startX = max(0, floor((min(tri[0], tri[3], tri[6])) * divNum));
			var startY = max(0, floor((min(tri[1], tri[4], tri[7])) * divNum));
			var startZ = max(0, floor((min(tri[2], tri[5], tri[8])) * divNum));
			var endX = min(divNum-1, ceil((max(tri[0], tri[3], tri[6])) * divNum));
			var endY = min(divNum-1, ceil((max(tri[1], tri[4], tri[7])) * divNum));
			var endZ = min(divNum-1, ceil((max(tri[2], tri[5], tri[8])) * divNum));
			for (var xx = startX; xx <= endX; xx ++)
			{
				var _x = (xx + .5) * rSize;
				for (var yy = startY; yy <= endY; yy ++)
				{
					var _y = (yy + .5) * rSize;
					for (var zz = startZ; zz <= endZ; zz ++)
					{
						var _z = (zz + .5) * rSize;
						if (spart__tri_in_cube(tri, rSize * .5, _x, _y, _z))
						{
							var list = subdiv[# xx, yy + zz * divNum];
							if (list < 0)
							{
								list = ds_list_create();
								subdiv[# xx, yy + zz * divNum] = list;
							}
							ds_list_add(list, tri);
						}
					}
				}
			}
		}

		//Add particles randomly
		var partID = 0;
		repeat partNum
		{
			var success = false;
			while !success
			{
				var px = .5 + (.5 - random(1)) * sizex * scale;
				var py = .5 + (.5 - random(1)) * sizey * scale;
				var pz = .5 + (.5 - random(1)) * sizez * scale;
				var rx = floor(px * divNum);
				var ry = floor(py * divNum);
				var rz = floor(pz * divNum);
				var list = subdiv[# rx, ry + rz * divNum];
				if (list < 0){continue;}
		
				var minDist = .5;
				var minSign = 1;
				var triNum = ds_list_size(list);
				for (var i = 0; i < triNum; i ++)
				{
					var tri = list[| i];
					var D = ((px - tri[0]) * tri[9] + (py - tri[1]) * tri[10] + (pz - tri[2]) * tri[11]);
					if (abs(D) >= minDist){continue;}
			
					for (j = 0; j < 3; j ++)
					{
						var j1 = 3 * j;
						var j2 = (j1 + 3) mod 9;
						var t0 = px - tri[j1];
						var t1 = py - tri[j1+1];
						var t2 = pz - tri[j1+2];
						var u0 = tri[j2] - tri[j1];
						var u1 = tri[j2+1] - tri[j1+1];
						var u2 = tri[j2+2] - tri[j1+2];
						if ((t2 * u1 - t1 * u2) * tri[9] + (t0 * u2 - t2 * u0) * tri[10] + (t1 * u0 - t0 * u1) * tri[11] < 0)
						{
							var dp = clamp((u0 * t0 + u1 * t1 + u2 * t2) / (sqr(u0) + sqr(u1) + sqr(u2)), 0, 1);
							var dx = t0 - u0 * dp;
							var dy = t1 - u1 * dp;
							var dz = t2 - u2 * dp;
							var d = sqrt(sqr(dx) + sqr(dy) + sqr(dz));
							if (d < minDist)
							{
								minDist = d;
								minSign = 1;
							}
							break;
						}
					}
					if (j < 3){continue;}
					if (abs(D) < minDist)
					{
						minDist = abs(D);
						minSign = sign(D);
					}
				}
				if (minSign > 0){continue;} //The point should be inside the model, but it ended up outside! We need to restart the loop
		
				//Write the particle to the buffer
				for (var j = 2; j >= 0; j --)
				{
					buffer_write(meshBuff, buffer_u8, partID mod 256);
					buffer_write(meshBuff, buffer_u8, (partID div 256) mod 256);
					buffer_write(meshBuff, buffer_u8, partID div (256 * 256));
					buffer_write(meshBuff, buffer_u8, j); //Corner ID
			
					buffer_write(meshBuff, buffer_u8, floor(px * 255));
					buffer_write(meshBuff, buffer_u8, floor(py * 255));
					buffer_write(meshBuff, buffer_u8, floor(pz * 255));
					buffer_write(meshBuff, buffer_u8, floor(minDist * 2 * 255)); //Distance to nearest tri
				}
				for (var j = 1; j < 4; j ++)
				{
					buffer_write(meshBuff, buffer_u8, partID mod 256);
					buffer_write(meshBuff, buffer_u8, (partID div 256) mod 256);
					buffer_write(meshBuff, buffer_u8, partID div (256 * 256));
					buffer_write(meshBuff, buffer_u8, j); //Corner ID
			
					buffer_write(meshBuff, buffer_u8, floor(px * 255));
					buffer_write(meshBuff, buffer_u8, floor(py * 255));
					buffer_write(meshBuff, buffer_u8, floor(pz * 255));
					buffer_write(meshBuff, buffer_u8, floor(minDist * 2 * 255)); //Distance to nearest tri
				}
				success = true;
				partID ++;
			}
		}
	
		//Clean up
		for (var xx = 0; xx < divNum; xx ++)
		{
			for (var yy = 0; yy < divNum; yy ++)
			{
				for (var zz = 0; zz < divNum; zz ++)
				{
					var list = subdiv[# xx, yy + zz * divNum];
					if (list >= 0)
					{
						ds_list_destroy(list);
					}
				}
			}
		}
		ds_grid_destroy(subdiv);
	}

	var vbuff = vertex_create_buffer_from_buffer(meshBuff, sPartMeshFormat);
	vertex_freeze(vbuff);
	ds_list_destroy(triList);

	//Clean up
	if is_string(argument0)
	{
		buffer_delete(mbuff);
	}

	return [vbuff, meshBuff, 1 / scale, offsetx, offsety, offsetz, partNum, hollow];


}
