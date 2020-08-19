/// @description spart__submit_particles(partSystem, partEmitter, partType, partNum, uniformIndex)
/// @param partSystem
/// @param partEmitter
/// @param partType
/// @param partNum
/// @param uniformIndex
function spart__submit_particles(argument0, argument1, argument2, argument3, argument4) {
    /*
        This script splits particles up into batches and submits them to the GPU.
    
        Script created by TheSnidr
        www.TheSnidr.com
    */
    var partSystem = argument0;
    var partEmitter = argument1;
    var partType = argument2;
    var partNum = argument3;
    var i = argument4;
    var g = sPartUniformGrid;

    var tex = sprite_get_texture(partType[| sPartTyp.Spr], 0);

    partSystem[| sPartSys.ParticleNum] += partNum;

    //If the particle type is a mesh particle
    if partType[| sPartTyp.MeshEnabled]
    {
        var vbuff = partType[| sPartTyp.MeshVbuff];
        var particlesPerBatch = partType[| sPartTyp.MeshNumPerBatch];
        var batchNum = ceil(partNum / particlesPerBatch);
        partSystem[| sPartSys.DrawCalls] += batchNum;
        shader_set_uniform_f(g[# sPartUni.partNum, i], batchNum * particlesPerBatch);
        for (var k = 0; k < batchNum; k ++)
        {
            shader_set_uniform_f(g[# sPartUni.batchInd, i], k * particlesPerBatch);
            vertex_submit(vbuff, pr_trianglelist, tex);
        }
        exit;
    }

    //If the emitter is a mesh emitter
    if partEmitter[| sPartEmt.MeshPartNum] > 0
    {
        var vbuff = partEmitter[| sPartEmt.Mesh];
        var particlesPerBatch = partEmitter[| sPartEmt.MeshPartNum];
        var batchNum = ceil(partNum / particlesPerBatch);
        partSystem[| sPartSys.DrawCalls] += batchNum;
        shader_set_uniform_f(g[# sPartUni.partNum, i], batchNum * particlesPerBatch);
        shader_set_uniform_f_array(g[# sPartUni.emMeshOffset, i], partEmitter[| sPartEmt.MeshOffset]);
        for (var k = 0; k < batchNum; k ++)
        {
            shader_set_uniform_f(g[# sPartUni.batchInd, i], k * particlesPerBatch);
            vertex_submit(vbuff, pr_trianglelist, tex);
        }
        exit;
    }

    //Draw billboard particles
    var batchSizeArray = partSystem[| sPartSys.BatchSizeArray];
    var vertexBatchArray = partSystem[| sPartSys.VertexBatchArray];
    var indexNum = array_length(batchSizeArray);
    var index = 0;
    while (index < indexNum-1 && partNum > batchSizeArray[index])
    {
        index ++;
    }
    var vbuff = vertexBatchArray[index];
    var particlesPerBatch = batchSizeArray[index];
    var batchNum = ceil(partNum / particlesPerBatch);
    partSystem[| sPartSys.DrawCalls] += batchNum;
    shader_set_uniform_f(g[# sPartUni.partNum, i], batchNum * particlesPerBatch);
    for (var k = 0; k < batchNum; k ++)
    {
        shader_set_uniform_f(g[# sPartUni.batchInd, i], k * particlesPerBatch);
        vertex_submit(vbuff, pr_trianglelist, tex);
    }


}
