/// @param buffer
/// @param version
/// @param DataMapContainer

var buffer = argument0;
var version = argument1;
var map = argument2;
var map_contents = map.contents;

version = map.version;

if (version >= DataVersions.MAP_TILED_ID) {
    map.tiled_map_id = buffer_read(buffer, buffer_s32);
}

var xx = buffer_read(buffer, buffer_u16);
var yy = buffer_read(buffer, buffer_u16);
var zz = buffer_read(buffer, buffer_u16);

// it's an index now, but i'm going to make it a data type later, and this is
// in preparation for whenever i do that
if (version >= DataVersions.TS_ID) {
    map.tileset = buffer_read(buffer, buffer_datatype);
} else {
    map.tileset = buffer_read(buffer, buffer_u8);
}

data_resize_map(map, xx, yy, zz);

map.fog_start = buffer_read(buffer, buffer_f32);
map.fog_end = buffer_read(buffer, buffer_f32);

if (version >= DataVersions.EXTRA_FOG_PROPERTIES) {
    map.fog_colour = buffer_read(buffer, buffer_u32);
}

map.base_encounter_rate = buffer_read(buffer, buffer_u32);
map.base_encounter_deviation = buffer_read(buffer, buffer_u32);

var bools = buffer_read(buffer, buffer_u32);
map.indoors = unpack(bools, 0);
map.draw_water = unpack(bools, 1);
map.fast_travel_to = unpack(bools, 2);
map.fast_travel_from = unpack(bools, 3);
map.is_3d = unpack(bools, 4);

if (version >= DataVersions.EXTRA_FOG_PROPERTIES) {
    map.fog_enabled = unpack(bools, 5);
}

if (version >= DataVersions.MAP_GRID_PROPERTY) {
    map.on_grid = unpack(bools, 6);
}

map.code = buffer_read(buffer, buffer_string);

for (var i = 0; i < array_length_1d(map_contents.mesh_autotile_raw); i++) {
    var exists = buffer_read(buffer, buffer_bool);
    if (exists) {
        var size = buffer_read(buffer, buffer_u32);
        map_contents.mesh_autotile_raw[i] = buffer_read_buffer(buffer, size);
        map_contents.mesh_autotiles[i] = vertex_create_buffer_from_buffer(map_contents.mesh_autotile_raw[i], Stuff.graphics.vertex_format);
        vertex_freeze(map_contents.mesh_autotiles[i]);
    }
}