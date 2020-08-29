function omu_meshes_vertex_attribute_type(radio) {
    var list = radio.root.root.el_list;
    var format = Stuff.mesh_ed.formats[| radio.root.root.format_index];
    var index = ui_list_selection(list);
    if (!(index + 1)) return;
    format[? "attributes"][| index][? "type"] = radio.value;
}