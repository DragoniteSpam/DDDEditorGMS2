/// @param MenuMenu
function menu_activate(argument0) {

	var menu = argument0;
	Stuff.menu.active_element = menu;

	if (!menu) {
	    Stuff.menu.extra_element = noone;
	}


}
