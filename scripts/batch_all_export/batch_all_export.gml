/// @param DataMapContainer
/// @param chunk-size

var map = argument0;
var chunk_size = argument1;

var contents = map.contents;
var buffers = ds_map_create();

for (var index = 0; index < ds_list_size(contents.all_entities); index++) {
    var thing = contents.all_entities[| index];
    var bounds = script_execute(thing.get_bounding_box, thing);
    bounds[0] = bounds[0] div TILE_WIDTH;
    bounds[1] = bounds[1] div TILE_HEIGHT;
    bounds[2] = bounds[2] div TILE_DEPTH;
    bounds[3] = bounds[3] div TILE_WIDTH;
    bounds[4] = bounds[4] div TILE_HEIGHT;
    bounds[5] = bounds[5] div TILE_DEPTH;
    for (var i = bounds[0]; i < bounds[3]; i++) {
        for (var j = bounds[1]; j < bounds[4]; j++) {
            for (var k = bounds[2]; k < bounds[5]; k++) {
                var key = string(i) + ":" + string(j) + ":" + string(k);
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