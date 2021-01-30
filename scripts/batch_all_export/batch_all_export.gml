// This returns an array of vertex buffers
function batch_all_export(map, chunk_size) {
    var contents = map.contents;
    var buffers = { };
    
    for (var index = 0; index < ds_list_size(contents.all_entities); index++) {
        var thing = contents.all_entities[| index];
        if (thing.is_static) {
            var bounds = thing.get_bounding_box(thing);
            bounds.Chunk(chunk_size);
            for (var i = bounds.x1; i <= bounds.x2; i++) {
                for (var j = bounds.y1; j <= bounds.y2; j++) {
                    var key = (i << 24) | j;
                    if (!buffers[$ key]) {
                        buffers[$ key] = vertex_create_buffer();
                        vertex_begin(buffers[$ key], Stuff.graphics.vertex_format);
                    }
                    var vbuff = buffers[$ key];
                    thing.batch(vbuff, noone, undefined, undefined, thing);
                }
            }
        }
    }
    
    wtf("batch_all_export: figure out how to deal with wireframe buffers");
    
    var keys = variable_struct_get_names(buffers);
    for (var i = 0; i < array_length(keys); i++) {
        vertex_end(buffers[$ keys[i]]);
        keys[i] = buffers[$ keys[i]];
    }
    
    return keys;
}