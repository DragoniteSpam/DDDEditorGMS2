/// @param fname
/// @param DataMesh
/// @param vertex-format-json

var base_filename = argument0;
var mesh_filename = filename_path(base_filename) + string_replace(filename_name(base_filename), filename_ext(base_filename), "");
var mesh = argument1;
var format = argument2;

if (format) {
    format = format[? "attributes"];
    var vertex_base_size = 40;
    var vertex_new_size = 0;
    for (var i = 0; i < ds_list_size(format); i++) {
        var attribute = format[| i];
        // @gml chained accessors
        switch (attribute[? "type"]) {
            case VertexFormatData.POSITION_2D: vertex_new_size += 8; break;
            case VertexFormatData.POSITION_3D: vertex_new_size += 12; break;
            case VertexFormatData.NORMAL: vertex_new_size += 12; break;
            case VertexFormatData.TEXCOORD: vertex_new_size += 8; break;
            case VertexFormatData.COLOUR: vertex_new_size += 4; break;
        }
    }
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var sub = mesh.submeshes[| i];
        var fn = mesh_filename + "." + string_hex(i, 3) + filename_ext(base_filename);
        var vertex_count = buffer_get_size(sub.buffer) / vertex_base_size;
        var new_size = vertex_count * vertex_new_size;
        
        var formatted_buffer = buffer_create(new_size, buffer_fixed, 1);
        //buffer_save(formatted_buffer, fn);
        buffer_delete(formatted_buffer);
    }
} else {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var sub = mesh.submeshes[| i];
        var fn = mesh_filename + "." + string_hex(i, 3) + filename_ext(base_filename);
        buffer_save(sub.buffer, fn);
    }
}