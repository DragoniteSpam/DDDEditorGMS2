/// @param DataMapContainer
/// @param chunk-size

var map = argument0;
var chunk_size = argument1;

var contents = map.contents;
var buffers = ds_map_create();

for (var index = 0; index < ds_list_size(contents.all_entities); index++) {
    var thing = contents.all_entities[| index];
    if (thing.static) {
        var bounds = script_execute(thing.get_bounding_box, thing);
        bounds[0] = bounds[0] div chunk_size;
        bounds[1] = bounds[1] div chunk_size;
        bounds[3] = bounds[3] div chunk_size;
        bounds[4] = bounds[4] div chunk_size;
        for (var i = bounds[0]; i <= bounds[3]; i++) {
            for (var j = bounds[1]; j <= bounds[4]; j++) {
                var key = (i << 24) | j;
                if (!ds_map_exists(buffers, key)) {
                    buffers[? key] = vertex_create_buffer();
                    vertex_begin(buffers[? key], Stuff.graphics.vertex_format);
                }
                var vbuff = buffers[? key];
                script_execute(thing.batch, vbuff, noone, thing);
            }
        }
    }
}

for (var i = ds_map_find_first(buffers); i != undefined; i = ds_map_find_next(buffers, i)) {
    vertex_end(buffers[? i]);
}

return buffers;