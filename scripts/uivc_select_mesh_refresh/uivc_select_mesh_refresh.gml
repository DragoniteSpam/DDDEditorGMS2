/// @param index
function uivc_select_mesh_refresh(argument0) {

    var index = argument0;

    var data = Game.meshes[| Stuff.map.selection_fill_mesh];
    Stuff.map.ui.t_p_mesh_editor.element_tag = !!data;

    if (data) {
        var thing = Stuff.map.ui.t_p_mesh_editor;
        ui_input_set_value(thing.mesh_name, data.name);
        ui_input_set_value(thing.mesh_name_internal, data.internal_name);
    
        ui_input_set_value(thing.xmin, string(data.xmin));
        ui_input_set_value(thing.xmax, string(data.xmax));
        ui_input_set_value(thing.ymin, string(data.ymin));
        ui_input_set_value(thing.ymax, string(data.ymax));
        ui_input_set_value(thing.zmin, string(data.zmin));
        ui_input_set_value(thing.zmax, string(data.zmax));
    }


}
