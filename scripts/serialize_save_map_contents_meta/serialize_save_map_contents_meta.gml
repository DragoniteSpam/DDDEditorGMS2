/// @param buffer

var buffer = argument0;
var map = Stuff.active_map;
var map_contents = map.contents;

buffer_write(buffer, buffer_datatype, SerializeThings.MAP_META);

buffer_write(buffer, buffer_u16, map.xx);
buffer_write(buffer, buffer_u16, map.yy);
buffer_write(buffer, buffer_u16, map.zz);

buffer_write(buffer, buffer_u8, map.tileset);

buffer_write(buffer, buffer_f32, map.fog_start);
buffer_write(buffer, buffer_f32, map.fog_end);
buffer_write(buffer, buffer_u32, map.base_encounter_rate);
buffer_write(buffer, buffer_u32, map.base_encounter_deviation);

var bools = pack(map.indoors, map.draw_water, map.fast_travel_to,
	map.fast_travel_from, map.is_3d);

buffer_write(buffer, buffer_u32, bools);
buffer_write(buffer, buffer_string, map.code);

for (var i = 0; i < array_length_1d(map.mesh_autotile_raw); i++) {
    var data = map.mesh_autotile_raw[i];
    if (data) {
        buffer_write(buffer, buffer_bool, true);
        buffer_write(buffer, buffer_u32, buffer_get_size(data));
        buffer_write_buffer(buffer, data);
    } else {
        buffer_write(buffer, buffer_bool, false);
    }
}