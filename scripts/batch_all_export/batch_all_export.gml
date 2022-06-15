// This returns an array of { raw, raw_reflected }
function batch_all_export(map, chunk_size) {
    var contents = map.contents;
    var buffers = { };
    
    var n = 0;
    
    for (var index = 0; index < ds_list_size(contents.all_entities); index++) {
        var thing = contents.all_entities[| index];
        if (!thing.is_static) continue;
        
        var bounds = thing.get_bounding_box().Chunk(chunk_size);
        for (var i = bounds.x1; i <= bounds.x2; i++) {
            for (var j = bounds.y1; j <= bounds.y2; j++) {
                // the horizontal coordinate is in the upper 24 bits
                // the vertical coordinate is in the lower 24 bits
                var key = string((i << 24) | j);
                if (!buffers[$ key]) {
                    buffers[$ key] = {
                        raw: vertex_create_buffer(),
                        raw_reflected: vertex_create_buffer(),
                        // the key could totally be a stirng, but we still
                        // are going to need to extract the coords later
                        key: key,
                    };
                    vertex_begin(buffers[$ key].raw, Stuff.graphics.format);
                    vertex_begin(buffers[$ key].raw_reflected, Stuff.graphics.format);
                }
                var vbuff = buffers[$ key];
                thing.batch(vbuff.raw, vbuff.raw_reflected, thing);
            }
        }
    }
    
    var keys = variable_struct_get_names(buffers);
    for (var i = 0, n = array_length(keys); i < n; i++) {
        var chunk = buffers[$ keys[i]];
        vertex_end(chunk.raw);
        vertex_end(chunk.raw_reflected);
        
        var data = buffer_create_from_vertex_buffer(chunk.raw, buffer_fixed, 1);
        vertex_delete_buffer(chunk.raw);
        chunk.raw = data;
        if (vertex_get_number(chunk.raw_reflected) == 0) {
            data = buffer_create(0, buffer_fixed, 1);
        } else {
            data = buffer_create_from_vertex_buffer(chunk.raw_reflected, buffer_fixed, 1);
        }
        vertex_delete_buffer(chunk.raw_reflected);
        chunk.raw_reflected = data;
        keys[i] = chunk;
    }
    
    return keys;
}