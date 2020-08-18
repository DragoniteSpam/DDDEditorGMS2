/// @param UIList
function omu_meshes_mat_set_alpha(argument0) {

	var list = argument0;
	var selection = ui_list_selection(list);

	for (var i = ds_map_find_first(list.root.selection); i != undefined; i = ds_map_find_next(list.root.selection, i)) {
	    Stuff.all_meshes[| i].tex_alpha = (selection + 1) ? Stuff.all_graphic_tilesets[| selection].GUID : NULL;
	}


}
