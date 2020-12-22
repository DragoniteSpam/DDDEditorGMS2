function batch_all_export(map, chunk_size) {
    var contents = map.contents;
    var buffers = ds_map_create();
    
    for (var index = 0; index < ds_list_size(contents.all_entities); index++) {
        var thing = contents.all_entities[| index];
        if (thing.is_static) {
            var bounds = thing.get_bounding_box(thing);
            bounds.Chunk(chunk_size);
            for (var i = bounds.x1; i <= bounds.x2; i++) {
                for (var j = bounds.y1; j <= bounds.y2; j++) {
                    var key = (i << 24) | j;
                    if (!ds_map_exists(buffers, key)) {
                        buffers[? key] = vertex_create_buffer();
                        vertex_begin(buffers[? key], Stuff.graphics.vertex_format);
                    }
                    var vbuff = buffers[? key];
                    thing.batch(vbuff, noone, thing);
                }
            }
        }
    }
    
    for (var i = ds_map_find_first(buffers); i != undefined; i = ds_map_find_next(buffers, i)) {
        vertex_end(buffers[? i]);
    }
    
    return buffers;
}