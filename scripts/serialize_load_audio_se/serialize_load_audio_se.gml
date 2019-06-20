/// @param buffer
/// @param version

var version = argument1;

ds_list_clear_instances(Stuff.all_se);
var n_se = buffer_read(argument0, buffer_u16);

for (var i = 0; i < n_se; i++) {
    var se = instantiate(DataAudio);
    
    serialize_load_generic(argument0, se, version);
    
    se.temp_name = buffer_read(argument0, buffer_string);
    var length = buffer_read(argument0, buffer_u32);
    var fbuffer = buffer_create(length, buffer_fixed, 1);
    buffer_copy(argument0, buffer_tell(argument0), length, fbuffer, 0);
    buffer_seek(argument0, buffer_seek_relative, length);
    buffer_save(fbuffer, se.temp_name);
    buffer_delete(fbuffer);
    
    if (length == 0) {
        debug("Audio file not embedded, you probably want to re-load: " + string(se.GUID) + " [" + se.name + "]");
    } else {
        se.fmod = FMODGMS_Snd_LoadStream(environment_get_variable("localappdata") + "\\DDDEditor2\\" + se.temp_name);
    }
    
    ds_list_add(Stuff.all_se, se);
}