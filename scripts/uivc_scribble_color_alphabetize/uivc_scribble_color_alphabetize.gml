/// @param UIButton
function uivc_scribble_color_alphabetize(argument0) {

	var button = argument0;
	var list = button.root.el_list;
	var mode = Stuff.scribble;
	ui_list_deselect(list);
	ds_list_sort(mode.scribble_colours, true);
	list.root.el_add.interactive = false;
	list.root.el_remove.interactive = false;
	list.root.el_name.interactive = false;
	list.root.el_value.interactive = false;
	ui_activate(noone);


}
