function omu_meshes_vertex_attribute_name(input) {
    var list = input.root.el_list;
    var format = Stuff.mesh_ed.formats[| input.root.format_index];
    var index = ui_list_selection(list);
    if (!(index + 1)) return;
    list.entries[| index] = input.value;
    format[? "attributes"][| index][? "name"] = input.value;
}