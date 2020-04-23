/// @param DataMapContainer
/// @param chunk-size

var map = argument0;
var chunk_size = argument1;

var contents = map.contents;
var buffers = ds_map_create();

for (var i = 0; i < ds_list_size(map.all_entities); i++) {
    var thing = map.all_entities[| i];
    var bounds = script_execute(thing.get_bounding_box, thing);
    script_execute(thing.batch, map.preview, map.wpreview, thing);
    script_execute(thing.batch_collision, map.cspreview, thing);
}

return buffers;