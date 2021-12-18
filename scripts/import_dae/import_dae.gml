function import_dae(filename, adjust_uvs = true, existing = undefined, replace_index = -1) {
    var container = dotdae_model_load_file(filename);
    
    var base_name = filename_change_ext(filename_name(filename), "");
    var mesh = new DataMesh(base_name);
    array_push(Game.meshes, mesh);
    
    var geometry = container[eDotDae.GeometryList];
    var mesh_array = geometry[| 0][eDotDaeGeometry.MeshArray];
    var vbuff_array = mesh_array[0][eDotDaeMesh.VertexBufferArray];
    
    for (var i = 0; i < array_length(vbuff_array); i++) {
        var poly_list = vbuff_array[i];
        var vbuff = buffer_dotobj_to_standard(poly_list);
        var buff = buffer_create_from_vertex_buffer(vbuff, buffer_fixed, 1);
        mesh_create_submesh(mesh, buff, vbuff);
    }
    
    /*
    var container = dotdae_model_load_file(filename, false, false);
    var vbs = container[@ eDotDae.VertexBufferList];

    if (everything) {
        var cshape = c_shape_create();
        c_shape_begin_trimesh();
        c_shape_end_trimesh(cshape);
    
        var base_name = filename_change_ext(filename_name(filename), "");
        var mesh = existing ? existing : new DataMesh(base_name);
        if (!existing) array_push(Game.meshes, mesh);
    
        if (!existing) {
            mesh.xmin = 0;
            mesh.ymin = 0;
            mesh.zmin = 0;
            mesh.xmax = 1;
            mesh.ymax = 1;
            mesh.zmax = 1;
        
            data_mesh_recalculate_bounds(mesh);
            internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
        }
    
        if (mesh.cshape) {
            c_shape_destroy(cshape);
            cshape = mesh.cshape;
        }
    
        for (var i = 0; i < ds_list_size(vbs); i++) {
            var vbuffer = vbs[| i];
            vbuffer = vbuffer[@ eDotDaePolyList.VertexBuffer];
            mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1), vbuffer, undefined, base_name, replace_index, filename);
            vertex_freeze(vbuffer);
        }
    
        return mesh;
    }

    return container;

*/
}
