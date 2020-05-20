/// @param DataMesh
/// @param scale
/// @param [index]
/// @param [set-scale?]

var mesh = argument[0];
var scale = argument[1];
var index = (argument_count > 2) ? argument[2] : undefined;
var set_scale = (argument_count > 3 && argument[3] != undefined) ? argument[3] : true;

if (set_scale) {
    var f = scale / mesh.texture_scale;
    mesh.texture_scale = scale;
} else {
    var f = scale;
}

var istart = (index == undefined) ? 0 : index;
var iend = (index == undefined) ? ds_list_size(mesh.submeshes) : (index + 1);

for (var i = istart; i < iend; i++) {
    var submesh = mesh.submeshes[| i];
    var buffer = submesh.buffer;
    buffer_seek(buffer, buffer_seek_start, 0);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var position = buffer_tell(buffer);
        
        var tu = buffer_peek(buffer, position + 24, buffer_f32);
        var tv = buffer_peek(buffer, position + 28, buffer_f32);
        buffer_poke(buffer, position + 24, buffer_f32, tu * f);
        buffer_poke(buffer, position + 28, buffer_f32, tv * f);
        
        buffer_seek(buffer, buffer_seek_relative, Stuff.graphics.format_size);
    }
    
    buffer_seek(buffer, buffer_seek_start, 0);
    
    vertex_delete_buffer(submesh.vbuffer);
    submesh.vbuffer = vertex_create_buffer_from_buffer(buffer, Stuff.graphics.vertex_format);
    vertex_freeze(submesh.vbuffer);
    
    // no actual vertex data has changed, so we can keep the wbuffer
}

batch_again();