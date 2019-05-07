/// @description  void data_load_vra_actually_thanks(filename);
/// @param filename
// this must be run inside of object Stuff. if you call it anywhere else
// in the code, use with (Stuff), otherwise bad things will happen.

vra_name=filename_name(argument0);

var alphabetizer=ds_priority_create();

var buffer=buffer_load(argument[0]);

var conflicts_output=file_text_open_write("conflicts.txt");
var conflicts_identified=false;

var data=ds_map_create();
ds_map_read(data, buffer_read_string(buffer));

var version=data[? "version"];
if (ds_map_exists(data, "grid_size")){
    var grid_size=data[? "grid_size"];
} else {
    var grid_size=0;
}

if (ds_map_size(vra_data)>0){
    var key=ds_map_find_first(vra_data);
    while (key!=ds_map_find_last(vra_data)){
        var mesh_data=vra_data[? key];
        vertex_delete_buffer(mesh_data[@ MeshArrayData.VBUFF]);
        buffer_delete(mesh_data[@ MeshArrayData.DATA]);
        key=ds_map_find_next(vra_data, key);
    }
}

ds_map_destroy(data);

ds_map_clear(vra_data);

var n=buffer_read(buffer, T);

repeat(n){
    var model_name=buffer_read_string(buffer);
    var stuff=data_load_vra_next(buffer, grid_size);
    // if the name is already in use, destroy the new one
    // todo make a note of this somewhere
    if (ds_map_exists(vra_data, model_name)){
        vertex_delete_buffer(stuff[@ MeshArrayData.VBUFF]);
        buffer_delete(stuff[@ MeshArrayData.DATA]);
        file_text_write_string(conflicts_output, model_name);
        file_text_writeln(conflicts_output);
        conflicts_identified=true;
    } else {
        vra_data[? model_name]=stuff;
        ds_priority_add(alphabetizer, model_name, model_name);
    }
}

buffer_delete(buffer);

// alphabetize it

ds_list_clear(all_mesh_names);

while (!ds_priority_empty(alphabetizer)){
    ds_list_add(all_mesh_names, ds_priority_delete_min(alphabetizer));
}

ds_priority_destroy(alphabetizer);

// update ui mesh list

var n=ds_list_size(all_mesh_names);
var ui_list=Camera.ui.element_mesh_list;
ui_list_clear(ui_list);
ui_list.text="Available meshes: "+string(n);
for (var i=0; i<n; i++){
    create_list_entries(ui_list, all_mesh_names[| i], c_black);
}

file_text_close(conflicts_output);

if (conflicts_identified){
    create_notification(vra_name+" contained naming conflicts. Go to Data > View Mesh Conflicts to see the list.");
}
