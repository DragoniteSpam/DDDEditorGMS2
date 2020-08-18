/// @param selection-type
/// @param xx
/// @param yy
/// @param zz
function selection_add(argument0, argument1, argument2, argument3) {

	var stype = argument0;
	var xx = argument1;
	var yy = argument2;
	var zz = argument3;
	var mode = Stuff.map;

	var selection = instance_create_depth(0, 0, 0, stype);
	ds_list_add(mode.selection, selection);
	script_execute(selection.onmousedown, selection, xx, yy, zz);

	return selection;


}
