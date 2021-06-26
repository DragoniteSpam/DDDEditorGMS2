// This returns an array of { vbuffer, reflected }
function batch_all_export(map, chunk_size) {
    var contents = map.contents;
    var buffers = { };
    
    for (var index = 0; index < ds_list_size(contents.all_entities); index++) {
        var thing = contents.all_entities[| index];
        if (thing.is_static) {
            var bounds = thing.get_bounding_box(thing).Chunk(chunk_size);
            for (var i = bounds.x1; i <= bounds.x2; i++) {
                for (var j = bounds.y1; j <= bounds.y2; j++) {
                    // the horizontal coordinate is in the upper 24 bits
                    // the vertical coordinate is in the lower 24 bits
                    var key = (i << 24) | j;
                    if (!buffers[$ key]) {
                        buffers[$ key] = {
                            vbuffer: vertex_create_buffer(),
                            reflected: vertex_create_buffer(),
                            // the key could totally be a stirng, but we still
                            // are going to need to extract the coords later
                            key: key,
                        };
                        vertex_begin(buffers[$ key].vbuffer, Stuff.graphics.vertex_format);
                        vertex_begin(buffers[$ key].reflected, Stuff.graphics.vertex_format);
                    }
                    var vbuff = buffers[$ key];
                    thing.batch(vbuff.vbuffer, undefined, vbuff.reflected, undefined, thing);
                }
            }
        }
    }
    
    var keys = variable_struct_get_names(buffers);
    for (var i = 0; i < array_length(keys); i++) {
        vertex_end(buffers[$ keys[i]].vbuffer);
        vertex_end(buffers[$ keys[i]].reflected);
        keys[i] = buffers[$ keys[i]];
    }
    
    return keys;
}