function momu_set_starting_position_down() {
    menu_close_all();
    if (array_length(Stuff.map.selection) == 1) {
        var selection = Stuff.map.selection[0];
        if (selection.area() == 1) {
            Game.meta.start.map = Stuff.map.active_map.GUID;
            Game.meta.start.x = selection.x;
            Game.meta.start.y = selection.y;
            Game.meta.start.z = selection.z;
            Game.meta.start.direction = 0;
        }
    }
}

function momu_set_starting_position_up() {
    menu_close_all();
    // this list being referenced is the selection of the UIList, because
    // it turns out i didn't name that variable very well. it's not the
    // selection in map mode, even though it kinda looks like it.
    if (array_length(Stuff.map.selection) == 1) {
        var selection = Stuff.map.selection[0];
        if (selection.area() == 1) {
            Game.meta.start.map = Stuff.map.active_map.GUID;
            Game.meta.start.x = selection.x;
            Game.meta.start.y = selection.y;
            Game.meta.start.z = selection.z;
            Game.meta.start.direction = 3;
        }
    }
}

function momu_set_starting_position_left() {
    menu_close_all();
    if (array_length(Stuff.map.selection) == 1) {
        var selection = Stuff.map.selection[0];
        if (selection.area() == 1) {
            Game.meta.start.map = Stuff.map.active_map.GUID;
            Game.meta.start.x = selection.x;
            Game.meta.start.y = selection.y;
            Game.meta.start.z = selection.z;
            Game.meta.start.direction = 1;
        }
    }
}

function momu_set_starting_position_right() {
    menu_close_all();
    if (array_length(Stuff.map.selection) == 1) {
        var selection = Stuff.map.selection[0];
        if (selection.area() == 1) {
            Game.meta.start.map = Stuff.map.active_map.GUID;
            Game.meta.start.x = selection.x;
            Game.meta.start.y = selection.y;
            Game.meta.start.z = selection.z;
            Game.meta.start.direction = 2;
        }
    }
}