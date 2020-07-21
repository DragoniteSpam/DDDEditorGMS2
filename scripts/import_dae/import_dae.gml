/// @param filename
/// @param [adjust-UVs?]

var filename = argument[0];
var everything = (argument_count > 1 && argument[1] != undefined) ? argument[1] : true;
var adjust = (argument_count > 2 && argument[2] != undefined) ? argument[2] : true;
var existing = (argument_count > 3 && argument[3] != undefined) ? argument[3] : noone;
var replace_index = (argument_count > 4 && argument[4] != undefined) ? argument[4] : -1;

return;

var container = dotdae_model_load_file(filename, false, false);
var vbs = container[@ eDotDae.VertexBufferList];

if (everything) {
    var wbuffer = vertex_create_buffer();
    vertex_begin(wbuffer, Stuff.graphics.vertex_format);
    vertex_point_complete(wbuffer, 0, 0, 0, 0, 0, 1, 0, 0, c_white, 1);
    vertex_point_complete(wbuffer, 0, 10, 0, 0, 0, 1, 0, 1, c_white, 1);
    vertex_point_complete(wbuffer, 10, 0, 0, 0, 0, 1, 1, 0, c_white, 1);
    vertex_end(wbuffer);
    var cshape = c_shape_create();
    c_shape_begin_trimesh();
    c_shape_end_trimesh(cshape);
    
    var base_name = filename_change_ext(filename_name(filename), "");
    var mesh = existing ? existing : instance_create_depth(0, 0, 0, DataMesh);
    
    if (!existing) {
        mesh.xmin = 0;
        mesh.ymin = 0;
        mesh.zmin = 0;
        mesh.xmax = 1;
        mesh.ymax = 1;
        mesh.zmax = 1;
        
        mesh.name = base_name;
        data_mesh_recalculate_bounds(mesh);
        internal_name_generate(mesh, PREFIX_MESH + string_lettersdigits(base_name));
    }
    
    if (mesh.cshape) {
        c_shape_destroy(cshape);
        cshape = mesh.cshape;
    }
    
    vertex_freeze(wbuffer);
    
    for (var i = 0; i < ds_list_size(vbs); i++) {
        var vbuffer = vbs[| i];
        vbuffer = vbuffer[@ eDotDaePolyList.VertexBuffer];
        mesh_create_submesh(mesh, buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1), vbuffer, wbuffer, undefined, base_name, replace_index, filename);
        vertex_freeze(vbuffer);
    }
    
    return mesh;
}

return container;