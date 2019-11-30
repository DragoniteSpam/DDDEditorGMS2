/// @param MenuElement

var element = argument0;

if (ds_list_size(Stuff.map.selection) == 1) {
    var selection = Stuff.map.selection[| 0];
    if (script_execute(selection.area, selection) == 1) {
        Stuff.game_starting_map = Stuff.map.active_map.GUID;
        Stuff.game_starting_x = selection.x;
        Stuff.game_starting_y = selection.y;
        Stuff.game_starting_z = selection.z;
        Stuff.game_starting_direction = 2;
    }
}

menu_activate(noone);