/// @param UIList

var list = argument0;

var selection = ui_list_selection(list);

if (selection >= 0) {
	var what = list.entries[| selection];
	list.root.el_name.value = what.name;
	list.root.el_internal_name.value = what.internal_name;
	list.root.el_summary.value = what.summary;
	list.root.el_dim_x.value = string(what.xx);
	list.root.el_dim_y.value = string(what.yy);
	list.root.el_dim_z.value = string(what.zz);
}