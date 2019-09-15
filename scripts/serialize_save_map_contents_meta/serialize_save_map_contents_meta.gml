/// @param buffer

var buffer = argument0;
var map = Stuff.active_map;
var map_contents = map.contents;

buffer_write(buffer, buffer_datatype, SerializeThings.MAP_META);

buffer_write(buffer, buffer_u16, map_contents.xx);
buffer_write(buffer, buffer_u16, map_contents.yy);
buffer_write(buffer, buffer_u16, map_contents.zz);

buffer_write(buffer, buffer_u8, map.tileset);

buffer_write(buffer, buffer_f32, map_contents.fog_start);
buffer_write(buffer, buffer_f32, map_contents.fog_end);
buffer_write(buffer, buffer_u32, map_contents.base_encounter_rate);
buffer_write(buffer, buffer_u32, map_contents.base_encounter_deviation);

var bools = pack(map_contents.indoors, map_contents.draw_water, map_contents.fast_travel_to, map_contents.fast_travel_from,
    map.is_3d);

buffer_write(buffer, buffer_u32, bools);
buffer_write(buffer, buffer_string, map_contents.code);

for (var i = 0; i < array_length_1d(map_contents.mesh_autotile_raw); i++) {
    var data = map_contents.mesh_autotile_raw[i];
    if (data) {
        buffer_write(buffer, buffer_bool, true);
        buffer_write(buffer, buffer_u32, buffer_get_size(data));
        buffer_write_buffer(buffer, data);
    } else {
        buffer_write(buffer, buffer_bool, false);
    }
}