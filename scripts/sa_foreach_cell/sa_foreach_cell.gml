/// @description void sa_foreach_cell(script, params array);
/// @param script
/// @param params array
// processes each cell in the selection, but only once

var processed=ds_map_create();

for (var s=0; s<ds_list_size(selection); s++) {
    var sel=selection[| s];
    script_execute(sel.foreach_cell, sel, processed, argument0, argument1);
}

ds_map_destroy(processed);
