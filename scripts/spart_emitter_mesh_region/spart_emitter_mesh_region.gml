/// @description spart_emitter_mesh_region(ind, M[16], xsize, ysize, zsize, emitterMesh, dynamic)
/// @param ind
/// @param M[16]
/// @param xsize
/// @param ysize
/// @param zsize
/// @param emitterMesh
/// @param dynamic
function spart_emitter_mesh_region(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
    /*
        Change the orientation, scale and shape of the emitter. This particular script allows you to
        make an emitter that only emits particles within the confines of the given emitter mesh.
        emitterMesh must have been created beforehand using spart_emitter_mesh_preprocess on a model, like this:
    
            var obj = spart__load_obj_to_buffer(objPath);
            emitterMesh = spart_emitter_mesh_preprocess(obj, partNum, hollow);
            spart_emitter_mesh_save(emitterMesh, cachePath);
            buffer_delete(obj);
    
        Set dynamic to true if you'd like the particles that have already been created
        to finish drawing with the old settings.
    
        M must be a matrix WITHOUT SCALING. This is important!
        Scaling must be supplied on its own in the next three arguments.
        You can build an orientation matrix like this:
        matrix_build(x, y, z, xrot, yrot, zrot, 1, 1, 1);

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partEmitter = argument0;
    var M = argument1;
    var xSize = argument2;
    var ySize = argument3;
    var zSize = argument4;
    var mesh = argument5;
    var dynamic = argument6;

    var partType = partEmitter[| sPartEmt.PartType];
    if partType[| sPartTyp.MeshVbuff] >= 0
    {
        show_debug_message("Error in script spart_emitter_mesh: Cannot use mesh particles for mesh emitters");
        exit;
    }
    if !is_array(mesh){return false;}

    spart_emitter_region(partEmitter, M, xSize, ySize, zSize, 0, 0, dynamic);
    partEmitter[| sPartEmt.Mesh] = mesh[0];
    partEmitter[| sPartEmt.MeshOffset] = [mesh[3], mesh[4], mesh[5], mesh[2]];
    partEmitter[| sPartEmt.MeshPartNum] = mesh[6];


}
