/// @description  void selection_foreach_cell_single(selection, processed, script, params array);
/// @param selection
/// @param  processed
/// @param  script
/// @param  params array

var catch=argument1;

var str=string(argument0.x)+","+string(argument0.y)+","+string(argument0.z);

if (!ds_map_exists(argument1, str)){
    ds_map_add(argument1, str, true);
    script_execute(argument2, argument0.x, argument0.y, argument0.z, argument3);
}
