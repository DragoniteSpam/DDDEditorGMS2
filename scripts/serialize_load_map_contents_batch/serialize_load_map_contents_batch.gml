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
    map_contents.frozen_data = buffer_read_buffer(buffer, length);
    var length = buffer_read(buffer, buffer_u64);
    map_contents.frozen_data_wire = buffer_read_buffer(buffer, length);
    
    if (buffer_get_size(map_contents.frozen_data_wire) - 1) {
        map_contents.frozen = vertex_create_buffer_from_buffer(map_contents.frozen_data, Camera.vertex_format);
        vertex_freeze(map_contents.frozen);
    }
    if (buffer_get_size(map_contents.frozen_data_wire) - 1) {
        map_contents.frozen_wire = vertex_create_buffer_from_buffer(map_contents.frozen_data_wire, Camera.vertex_format);
        vertex_freeze(map_contents.frozen_wire);
    }
}

Please:
 - Passability of frozen tiles in the world should be based on the passability of the tiles in the tileset
    and saved as a non-object of some sort to the contents grid (probably just by giving it the passability
    mask instead of the instance ID - that sounds awful but it's better than keeping an entire separate grid
    for frozen entities - i hate computers) and this should all be able to be saved and loaded from the data
    file
 - update the game to use this new information
 - figure out why it takes a good ten seconds to load a mostly-empty dddd file - the profiler is breaking
    after trying to profile a single frame for multiple seconds so youll need to do it the sucky way