/// @description void serialize_save_map_contents_meta(buffer);
/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.MAP_META);

// unlike most other data types we don't save in a loop here because
// there can only be one map loaded at a time

buffer_write(argument0, buffer_string, ActiveMap.name);
buffer_write(argument0, buffer_string, ActiveMap.internal_name);
buffer_write(argument0, buffer_string, ActiveMap.summary);

buffer_write(argument0, buffer_u16, ActiveMap.xx);
buffer_write(argument0, buffer_u16, ActiveMap.yy);
buffer_write(argument0, buffer_u16, ActiveMap.zz);

buffer_write(argument0, buffer_u8, ActiveMap.tileset);

buffer_write(argument0, buffer_string, ActiveMap.audio_bgm);

var n_ambient=ds_list_size(ActiveMap.audio_ambient);
buffer_write(argument0, buffer_u16, n_ambient);
for (var i=0; i<n_ambient; i++) {
    buffer_write(argument0, buffer_string, ActiveMap.audio_ambient[| i]);
    buffer_write(argument0, buffer_u8, ActiveMap.audio_ambient_frequencies[| i]);
}

buffer_write(argument0, buffer_f32, ActiveMap.fog_start);
buffer_write(argument0, buffer_f32, ActiveMap.fog_end);

var bools=pack(ActiveMap.indoors, ActiveMap.draw_water, ActiveMap.fast_travel_to, ActiveMap.fast_travel_from,
    ActiveMap.is_3d);

buffer_write(argument0, buffer_u32, bools);
