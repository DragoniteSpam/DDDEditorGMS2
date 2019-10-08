/// @param buffer
/// @param version
/// @param DataMapContainer

var buffer = argument0;
var version = argument1;
var map = argument2;
var map_contents = map.contents;

if (version >= DataVersions.MAP_BATCH_DATA) {
    buffer_delete(map_contents.frozen_data);
    buffer_delete(map_contents.frozen_data_wire);

    var length = buffer_read(buffer, buffer_u64);
    map_contents.frozen_data_size = buffer_read(buffer, buffer_u64);
    map_contents.frozen_data = buffer_read_buffer(buffer, length);
    var length = buffer_read(buffer, buffer_u64);
    map_contents.frozen_data_wire_size = buffer_read(buffer, buffer_u64);
    map_contents.frozen_data_wire = buffer_read_buffer(buffer, length);
    
    if (buffer_get_size(map_contents.frozen_data) - 1) {
        map_contents.frozen = vertex_create_buffer_from_buffer(map_contents.frozen_data, Camera.vertex_format);
        vertex_freeze(map_contents.frozen);
    }
    if (buffer_get_size(map_contents.frozen_data_wire) - 1) {
        map_contents.frozen_wire = vertex_create_buffer_from_buffer(map_contents.frozen_data_wire, Camera.vertex_format);
        vertex_freeze(map_contents.frozen_wire);
    }
}

if (version >= DataVersions.MAP_BATCH_SOLIDNESS_DATA) {
    var passage_count = buffer_read(buffer, buffer_u32);
    
    repeat (passage_count) {
        var xx = buffer_read(buffer, buffer_u16);
        var yy = buffer_read(buffer, buffer_u16);
        var zz = buffer_read(buffer, buffer_u16);
        var slot = buffer_read(buffer, buffer_u8);
        var mask = buffer_read(buffer, buffer_u16);
        map_add_thing_anonymous(mask, xx, yy, zz, map, slot);
    }
}

/*
Please:
 - update the game to use this new information
 - figure out why it takes a good ten seconds to load a mostly-empty dddd file - the profiler is breaking
    after trying to profile a single frame for multiple seconds so youll need to do it the sucky way*/