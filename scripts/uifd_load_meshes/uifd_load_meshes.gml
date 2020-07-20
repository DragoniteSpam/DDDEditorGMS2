/// @param UIThing
/// @param files[]

var thing = argument0;
var files = argument1;

var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj"]);

for (var i = 0; i < ds_list_size(filtered_list); i++) {
    import_obj(filtered_list[| i], true, false);
}