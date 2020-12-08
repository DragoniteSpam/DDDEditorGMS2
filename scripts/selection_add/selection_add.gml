function selection_add(stype, x, y, z) {
    var mode = Stuff.map;
    
    var selection = instance_create_depth(0, 0, 0, stype);
    ds_list_add(mode.selection, selection);
    selection.onmousedown(selection, x, y, z);
    
    return selection;
}