/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.AUDIO_SE);

var n_se = ds_list_size(Stuff.all_se);
buffer_write(argument0, buffer_u16, n_se);

for (var i = 0; i < n_se; i++) {
    var se = Stuff.all_se[| i];
}