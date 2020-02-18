/// @param UIButton

var button = argument0;
var mesh = button.root.mesh;
var list = button.root.el_list;
var selection = ui_list_selection(list);

if (selection + 1) {
    if (ds_list_size(mesh.buffers) == 1) {
        dialog_create_notice(button, "Please don't delete the last submesh!");
    } else {
        buffer_delete(mesh.buffers[| selection]);
        vertex_delete_buffer(mesh.vbuffers[| selection]);
        vertex_delete_buffer(mesh.wbuffers[| selection]);
        ds_list_delete(mesh.buffers, selection);
        ds_list_delete(mesh.vbuffers, selection);
        ds_list_delete(mesh.wbuffers, selection);
        ds_list_pop(list.entries);
        ui_list_deselect(list);
    }
}