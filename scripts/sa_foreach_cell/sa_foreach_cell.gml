/// @param script
/// @param params[]
function sa_foreach_cell(script, params) {
    // processes each cell in the selection, but only once
    var processed = ds_map_create();
    
    for (var s = 0; s < ds_list_size(Stuff.map.selection); s++) {
        var sel = Stuff.map.selection[| s];
        sel.foreach_cell(sel, processed, script, params);
    }
    
    ds_map_destroy(processed);
}