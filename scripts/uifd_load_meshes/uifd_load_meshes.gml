/// @param UIThing
/// @param files[]

var thing = argument0;
var files = argument1;

var filtered_list = ui_handle_dropped_files_filter(files, [".d3d", ".gmmod", ".obj", ".smf"]);

for (var i = 0; i < ds_list_size(filtered_list); i++) {
    var fn = filtered_list[| i];
    switch (filename_ext(fn)) {
        case ".obj": import_obj(fn, true, false); break;
        case ".d3d": case ".gmmod": import_d3d(fn, true, false); break;
        case ".smf": import_smf(fn);
    }
}