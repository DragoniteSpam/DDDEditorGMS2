/// @param MenuElement

var element = argument0;

if (ds_list_size(self.selection) == 1) {
	var selection = self.selection[| 0];
	if (script_execute(selection.area, selection) == 1) {
		Stuff.game_starting_map = Stuff.active_map.GUID;
		Stuff.game_starting_x = selection.x;
		Stuff.game_starting_y = selection.y;
		Stuff.game_starting_z = selection.z;
	}
}

menu_activate(noone);