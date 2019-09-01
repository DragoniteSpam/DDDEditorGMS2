/// @param UIThing

var thing = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];

if (data) {
    instance_activate_object(data);
    instance_destroy(data);
    ui_list_deselect(Camera.ui.element_mesh_list);
}