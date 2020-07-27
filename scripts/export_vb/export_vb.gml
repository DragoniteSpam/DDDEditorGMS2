/// @param fname
/// @param DataMesh
/// @param vertex-format-json

var base_filename = argument0;
var mesh_filename = filename_path(base_filename) + filename_change_ext(filename_name(base_filename), "");
var mesh = argument1;
var format = argument2;

if (format) {
    format = format[? "attributes"];
    var vertex_new_size = 0;
    var attribute_count = 0;
    for (var i = 0; i < ds_list_size(format); i++) {
        var attribute = format[| i];
        attribute_count++;
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
        var number_ext = (ds_list_size(mesh.submeshes) == 1) ? "" : ("!" + string_hex(i, 3));
        var sub = mesh.submeshes[| i];
        var fn = mesh_filename + number_ext + filename_ext(base_filename);
        var vertex_count = buffer_get_size(sub.buffer) / VERTEX_SIZE;
        var new_size = vertex_count * vertex_new_size;
        var base_position = 0;
        var formatted_buffer = buffer_create(new_size, buffer_fixed, 1);
        var current_attribute_count = 0;
        var attributes_used = [false, false, false, false];
        var index = 0;
        
        while (index < vertex_count) {
            var attribute = format[| current_attribute_count++];
            var attribute_type = attribute[? "type"];
            
            switch (attribute_type) {
                case VertexFormatData.POSITION_2D:
                    buffer_write(formatted_buffer, buffer_f32, 0);
                    buffer_write(formatted_buffer, buffer_f32, 0);
                    break;
                case VertexFormatData.POSITION_3D:
                    if (!attributes_used[0]) {
                        attributes_used[0] = true;
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(sub.buffer, base_position + 00, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(sub.buffer, base_position + 04, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(sub.buffer, base_position + 08, buffer_f32));
                    } else {
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                    }
                    break;
                case VertexFormatData.NORMAL:
                    if (!attributes_used[1]) {
                        attributes_used[1] = true;
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(sub.buffer, base_position + 12, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(sub.buffer, base_position + 16, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(sub.buffer, base_position + 20, buffer_f32));
                    } else {
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                    }
                    break;
                case VertexFormatData.TEXCOORD:
                    if (!attributes_used[2]) {
                        attributes_used[2] = true;
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(sub.buffer, base_position + 24, buffer_f32));
                        buffer_write(formatted_buffer, buffer_f32, buffer_peek(sub.buffer, base_position + 28, buffer_f32));
                    } else {
                        buffer_write(formatted_buffer, buffer_f32, 0);
                        buffer_write(formatted_buffer, buffer_f32, 0);
                    }
                    break;
                case VertexFormatData.COLOUR:
                    if (!attributes_used[3]) {
                        attributes_used[3] = true;
                        buffer_write(formatted_buffer, buffer_u32, buffer_peek(sub.buffer, base_position + 32, buffer_u32));
                    } else {
                        buffer_write(formatted_buffer, buffer_u32, 0);
                    }
                    break;
            }
            
            if (current_attribute_count == attribute_count) {
                current_attribute_count = 0;
                attributes_used = [false, false, false, false];
                base_position += VERTEX_SIZE;
                index++
            }
        }
        
        buffer_save(formatted_buffer, fn);
        buffer_delete(formatted_buffer);
    }
} else {
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var sub = mesh.submeshes[| i];
        var fn = mesh_filename + "." + string_hex(i, 3) + filename_ext(base_filename);
        buffer_save(sub.buffer, fn);
    }
}