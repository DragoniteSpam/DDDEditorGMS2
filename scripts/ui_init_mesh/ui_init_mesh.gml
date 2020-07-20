/// @param EditorModeMesh

var mode = argument0;

with (instance_create_depth(0, 0, 0, UIThing)) {
    var columns = 4;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
    var eh = 24;
    
    var c1x = cw * 0 + spacing;
    var c2x = cw * 1 + spacing;
    var c3x = cw * 2 + spacing;
    var c4x = cw * 3 + spacing;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_header = 64;
    var yy = 64 + eh;
    var yy_base = yy;
    
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    var element = create_list(c1x, yy, "Meshes:", "no meshes", ew, eh, 28, null, true, id, Stuff.all_meshes);
    element.render_colors = ui_list_colors_mesh_type_smf_disabled;
    element.entries_are = ListEntries.INSTANCES;
    mesh_list = element;
    ds_list_add(contents, element);
    yy += ui_get_list_height(element) + spacing;
    
    element = create_button(c1x, yy, "Add Mesh", ew, eh, fa_center, null, id);
    element.file_dropper_action = uifd_load_meshes;
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    element = create_button(c1x, yy, "Remove Mesh", ew, eh, fa_center, null, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    yy = yy_base;
    
    element = create_button(c2x, yy, "Export Selected", ew, eh, fa_center, omu_export_meshes_selected, id);
    ds_list_add(contents, element);
    yy += element.height + spacing;
    
    return id;
}