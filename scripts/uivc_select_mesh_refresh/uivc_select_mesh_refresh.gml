/// @param index

var index = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
Camera.ui.t_p_mesh_editor.element_tag = (data && true);

if (data) {
    var thing = Camera.ui.t_p_mesh_editor;
    ui_input_set_value(thing.element_tag, string(data.tags));
    ui_input_set_value(thing.mesh_name, data.name);
    ui_input_set_value(thing.mesh_name_internal, data.internal_name);
    
    ui_input_set_value(thing.xmin, string(data.xmin));
    ui_input_set_value(thing.xmax, string(data.xmax));
    ui_input_set_value(thing.ymin, string(data.ymin));
    ui_input_set_value(thing.ymax, string(data.ymax));
    ui_input_set_value(thing.zmin, string(data.zmin));
    ui_input_set_value(thing.zmax, string(data.zmax));
}