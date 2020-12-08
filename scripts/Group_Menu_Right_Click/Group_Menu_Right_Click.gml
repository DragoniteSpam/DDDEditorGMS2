function momu_set_starting_position_down() {
    menu_activate(noone);
    if (ds_list_size(Stuff.map.selection) == 1) {
        var selection = Stuff.map.selection[| 0];
        if (selection.area() == 1) {
            Stuff.game_starting_map = Stuff.map.active_map.GUID;
            Stuff.game_starting_x = selection.x;
            Stuff.game_starting_y = selection.y;
            Stuff.game_starting_z = selection.z;
            Stuff.game_starting_direction = 0;
        }
    }
}

function momu_set_starting_position_up() {
    menu_activate(noone);
    // this list being referenced is the selection of the UIList, because
    // it turns out i didn't name that variable very well. it's not the
    // selection in map mode, even though it kinda looks like it.
    if (ds_list_size(Stuff.map.selection) == 1) {
        var selection = Stuff.map.selection[| 0];
        if (selection.area() == 1) {
            Stuff.game_starting_map = Stuff.map.active_map.GUID;
            Stuff.game_starting_x = selection.x;
            Stuff.game_starting_y = selection.y;
            Stuff.game_starting_z = selection.z;
            Stuff.game_starting_direction = 3;
        }
    }
}

function momu_set_starting_position_left() {
    menu_activate(noone);
    if (ds_list_size(Stuff.map.selection) == 1) {
        var selection = Stuff.map.selection[| 0];
        if (selection.area() == 1) {
            Stuff.game_starting_map = Stuff.map.active_map.GUID;
            Stuff.game_starting_x = selection.x;
            Stuff.game_starting_y = selection.y;
            Stuff.game_starting_z = selection.z;
            Stuff.game_starting_direction = 1;
        }
    }
}

function momu_set_starting_position_right() {
    menu_activate(noone);
    if (ds_list_size(Stuff.map.selection) == 1) {
        var selection = Stuff.map.selection[| 0];
        if (selection.area() == 1) {
            Stuff.game_starting_map = Stuff.map.active_map.GUID;
            Stuff.game_starting_x = selection.x;
            Stuff.game_starting_y = selection.y;
            Stuff.game_starting_z = selection.z;
            Stuff.game_starting_direction = 2;
        }
    }
}