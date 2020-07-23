/// @param UIButton

var button = argument0;
var mode = Stuff.mesh_ed;

ds_list_add(mode.format_names, "Format" + string(ds_list_size(mode.format_names)));
var abuffer = buffer_load("data\\vertex-format-attributes.json");
ds_list_add(mode.formats, json_decode(buffer_read(abuffer, buffer_text)));
buffer_delete(abuffer);
ds_list_mark_as_map(mode.formats, ds_list_size(mode.formats) - 1);