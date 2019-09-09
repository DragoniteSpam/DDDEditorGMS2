/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.MAP_META);

// unlike most other data types we don't save in a loop here because
// there can only be one map loaded at a time

buffer_write(buffer, buffer_string, ActiveMap.name);
buffer_write(buffer, buffer_string, ActiveMap.internal_name);
buffer_write(buffer, buffer_string, ActiveMap.summary);

buffer_write(buffer, buffer_u16, ActiveMap.xx);
buffer_write(buffer, buffer_u16, ActiveMap.yy);
buffer_write(buffer, buffer_u16, ActiveMap.zz);

buffer_write(buffer, buffer_u8, ActiveMap.tileset);

buffer_write(buffer, buffer_f32, ActiveMap.fog_start);
buffer_write(buffer, buffer_f32, ActiveMap.fog_end);
buffer_write(buffer, buffer_u32, ActiveMap.base_encounter_rate);
buffer_write(buffer, buffer_u32, ActiveMap.base_encounter_deviation);

var bools = pack(ActiveMap.indoors, ActiveMap.draw_water, ActiveMap.fast_travel_to, ActiveMap.fast_travel_from,
    ActiveMap.is_3d);

buffer_write(buffer, buffer_u32, bools);
buffer_write(buffer, buffer_string, ActiveMap.code);

// MESH_AUTOTILE_INCLUSIONS

for (var i = 0; i < array_length_1d(ActiveMap.mesh_autotile_raw); i++) {
    var data = ActiveMap.mesh_autotile_raw[i];
    if (data) {
        buffer_write(buffer, buffer_bool, true);
        buffer_write(buffer, buffer_u32, buffer_get_size(data));
        buffer_write_buffer(buffer, data);
    } else {
        buffer_write(buffer, buffer_bool, false);
    }
}