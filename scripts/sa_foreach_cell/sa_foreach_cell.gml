/// @param script
/// @param params[]
// processes each cell in the selection, but only once

var script = argument0;
var params = argument1;

var processed = ds_map_create();

for (var s = 0; s < ds_list_size(selection); s++) {
    var sel = Stuff.map.selection[| s];
    script_execute(sel.foreach_cell, sel, processed, script, params);
}

ds_map_destroy(processed);