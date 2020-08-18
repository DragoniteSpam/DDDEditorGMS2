/// @param UIThing
function dmu_dialog_export_graphic(argument0) {

	var button = argument0;
	var list = button.root.el_list;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var what = list.entries[| selection];
	    var fn = get_save_filename_image(what.name + ".png");
	    if (fn != "") {
	        sprite_save(what.picture, 0, fn);
	        //ds_stuff_open(fn);
	    }
	}


}
