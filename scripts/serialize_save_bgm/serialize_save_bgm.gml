/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.AUDIO_BGM);

var n_bgm = ds_list_size(Stuff.all_bgm);
buffer_write(argument0, buffer_u16, n_bgm);

for (var i = 0; i < n_bgm; i++) {
    var bgm = Stuff.all_bgm[| i];
    buffer_write(argument0, buffer_f32, bgm.loop_start);
    buffer_write(argument0, buffer_f32, bgm.loop_end);
}