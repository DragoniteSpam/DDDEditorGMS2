/// @param UIButton
function omu_mesh_delete_sub(argument0) {

    var button = argument0;
    var mesh = button.root.mesh;
    var list = button.root.el_list;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        if (ds_list_size(mesh.submeshes) == 1) {
            dialog_create_notice(button, "Please don't delete the last submesh!");
        } else {
            instance_activate_object(mesh.submeshes[| selection]);
            instance_destroy(mesh.submeshes[| selection]);
            ds_list_delete(mesh.submeshes, selection);
            ui_list_deselect(list);
        }
    }


}
