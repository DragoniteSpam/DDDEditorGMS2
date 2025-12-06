// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function spart_emittermesh() constructor
{
    vbuff = -1;
    mBuff = -1;
    invScale = 1;
    x = 0;
    y = 0;
    z = 0;
    partNum = 0;
    
    function writeToBuffer(saveBuff)
    {
        //Write header
        buffer_write(saveBuff, buffer_string, "EmitterMesh");

        //Write mesh info
        buffer_write(saveBuff, buffer_f32, invScale);
        buffer_write(saveBuff, buffer_f32, x);
        buffer_write(saveBuff, buffer_f32, y);
        buffer_write(saveBuff, buffer_f32, z);
        buffer_write(saveBuff, buffer_u32, partNum);

        //Write mesh buffer
        var buffSize = buffer_get_size(mesh[1]);
        buffer_write(saveBuff, buffer_u64, buffSize);
        buffer_copy(mesh[1], 0, buffSize, saveBuff, buffer_tell(saveBuff));
        buffer_seek(saveBuff, buffer_seek_relative, buffSize);
    }
    
    function readFromBuffer(loadBuff) 
    {
        var mesh = array_create(6);

        //Make sure header is correct
        if (buffer_read(loadBuff, buffer_string) != "EmitterMesh")
        {
            return -1;
        }

        //Read mesh info
        invScale = buffer_read(loadBuff, buffer_f32);
        x = buffer_read(loadBuff, buffer_f32);
        y = buffer_read(loadBuff, buffer_f32);
        z = buffer_read(loadBuff, buffer_f32);
        partNum = buffer_read(loadBuff, buffer_u32);

        //Read mesh buffer
        var buffSize = buffer_read(loadBuff, buffer_u64);
        mBuff = buffer_create(buffSize, buffer_fixed, 1);
        buffer_copy(loadBuff, buffer_tell(loadBuff), buffSize, mBuff, 0);
        buffer_seek(loadBuff, buffer_seek_relative, buffSize);

        vbuff = vertex_create_buffer_from_buffer(mBuff, sPartMeshFormat);
        vertex_freeze(vbuff);

        return true;
    }
    
    /// @func preProcess(mesh, partNum)
    static preProcess = function(mesh, _partNum)
    {
        /*
            Preprocess the given mesh, creating all the possible particle positions within
            the mesh.
            Mesh can either be a buffer using the standard format, or the path to an OBJ file.
            Hollow mesh emitters are much faster to compute than non-hollow ones!

            Script created by TheSnidr
            www.thesnidr.com
        */
        //If the argument is a string, assume the user is trying to load an external file
        var load = false;
        if (is_string(mesh))
        {
            if (string_lower(filename_ext(mesh)) == ".obj")
            {
                load = true;
                mesh = spart_load_obj_to_buffer(mesh);
            }
            else
            {
                return spart_emittermesh_load(mesh);
            }
        }

        var bytesPerVert = 3 * 4 + 3 * 4 + 2 * 4 + 4 * 1;
        var vertNum = buffer_get_size(mesh) / bytesPerVert;
        partNum = _partNum;
        mBuff = buffer_create(8 * 6 * partNum, buffer_fixed, 1);

        //Find the outer boundaries of the vertex buffer
        var Min = [9999999, 9999999, 9999999];
        var Max = [-9999999, -9999999, -9999999];
        for (var i = 0; i < vertNum; i ++)
        {
            buffer_seek(mesh, buffer_seek_start, i * bytesPerVert);
            for (var j = 0; j < 3; j ++)
            {
                var v = buffer_read(mesh, buffer_f32);
                Min[j] = min(Min[j], v);
                Max[j] = max(Max[j], v);
            }
        }
        x = (Min[0] + Max[0]) / 2;
        y = (Min[1] + Max[1]) / 2;
        z = (Min[2] + Max[2]) / 2;
        invScale = max(Max[0] - Min[0], Max[1] - Min[1], Max[2] - Min[2], math_get_epsilon());
        scale = 1 / invScale;

        //Index the triangles
        var A = 0; //Total area
        var V = array_create(9);
        var triList = ds_list_create();
        buffer_seek(mesh, buffer_seek_start, 0);
        for (var i = 0; i < vertNum; i += 3)
        {
            for (var j = 0; j < 3; j ++)
            {
                for (var k = 0; k < 3; k ++)
                {
                    //Read vert position
                    V[j * 3 + k] = buffer_peek(mesh, (i + j) * bytesPerVert + k * 4, buffer_f32);
                }
            }
            var tri = array_create(14);
            tri[0] = .5 + (V[0] - x) * scale;
            tri[1] = .5 + (V[1] - y) * scale;
            tri[2] = .5 + (V[2] - z) * scale;
            tri[3] = .5 + (V[3] - x) * scale;
            tri[4] = .5 + (V[4] - y) * scale;
            tri[5] = .5 + (V[5] - z) * scale;
            tri[6] = .5 + (V[6] - x) * scale;
            tri[7] = .5 + (V[7] - y) * scale;
            tri[8] = .5 + (V[8] - z) * scale;
            var ux = tri[3] - tri[0];
            var uy = tri[4] - tri[1];
            var uz = tri[5] - tri[2];
            var vx = tri[6] - tri[0];
            var vy = tri[7] - tri[1];
            var vz = tri[8] - tri[2];
            var Nx = uy * vz - uz * vy;
            var Ny = uz * vx - ux * vz;
            var Nz = ux * vy - uy * vx;
            var l = sqrt(Nx * Nx + Ny * Ny + Nz * Nz);
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

        var partIndList = ds_list_create();
        for (var i = 0; i < partNum; i ++){partIndList[| i] = i;}
        ds_list_shuffle(partIndList);
        
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
                {    //Delete the triangle from the list if it contains too many particles
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
                    buffer_write(mBuff, buffer_u8, partInd mod 256);
                    buffer_write(mBuff, buffer_u8, (partInd div 256) mod 256);
                    buffer_write(mBuff, buffer_u8, partInd div (256 * 256));
                    buffer_write(mBuff, buffer_u8, j); //Corner ID
            
                    buffer_write(mBuff, buffer_u8, floor(px * 255));
                    buffer_write(mBuff, buffer_u8, floor(py * 255));
                    buffer_write(mBuff, buffer_u8, floor(pz * 255));
                    buffer_write(mBuff, buffer_u8, 0); //Distance to nearest tri
                }
                for (var j = 1; j < 4; j ++)
                {
                    buffer_write(mBuff, buffer_u8, partInd mod 256);
                    buffer_write(mBuff, buffer_u8, (partInd div 256) mod 256);
                    buffer_write(mBuff, buffer_u8, partInd div (256 * 256));
                    buffer_write(mBuff, buffer_u8, j); //Corner ID
            
                    buffer_write(mBuff, buffer_u8, floor(px * 255));
                    buffer_write(mBuff, buffer_u8, floor(py * 255));
                    buffer_write(mBuff, buffer_u8, floor(pz * 255));
                    buffer_write(mBuff, buffer_u8, 0); //Distance to nearest tri
                }
                num ++;
                if (num >= partNum){break;}
            }
        }

        vbuff = vertex_create_buffer_from_buffer(mBuff, sPartMeshFormat);
        vertex_freeze(vbuff);
        ds_list_destroy(triList);

        //Clean up
        if is_string(load)
        {
            buffer_delete(mesh);
        }
        return true;
    }
}

function spart_emittermesh_load(path)
{
    var emitterMesh = new spart_emittermesh();
    var ext = string_lower(filename_ext(path));
    if (ext == ".obj")
    {
        emitterMesh.preProcess(path);
        return emitterMesh;
    }
    var loadBuff = buffer_load(path);
    emitterMesh.readFromBuffer(loadBuff);
    return emitterMesh;
}