/// @param UIList
function ui_render_list_move_route_steps(argument0, argument1, argument2) {

    var list = argument0;

    var steps = list.root.route.steps;
    var otext = list.text;
    list.text = list.text + string(ds_list_size(steps));
    list.colorize = false;

    ds_list_clear(list.entries);

    for (var i = 0; i < ds_list_size(steps); i++) {
        var data = steps[| i];
        switch (data[@ 0]) {
            case MoveRouteActions.MOVE_DOWN: ds_list_add(list.entries, "Move Down: "+string(data[@ 1]) + " steps"); break;
            case MoveRouteActions.MOVE_UP: ds_list_add(list.entries, "Move Up: "+string(data[@ 1]) + " steps"); break;
            case MoveRouteActions.MOVE_LEFT: ds_list_add(list.entries, "Move Left: "+string(data[@ 1]) + " steps"); break;
            case MoveRouteActions.MOVE_RIGHT: ds_list_add(list.entries, "Move Right: "+string(data[@ 1]) + " steps"); break;
            case MoveRouteActions.MOVE_LOWER_LEFT: ds_list_add(list.entries, "Move Lower Left: "+string(data[@ 1]) + " steps"); break;
            case MoveRouteActions.MOVE_LOWER_RIGHT: ds_list_add(list.entries, "Move Lower Right: " + string(data[@ 1]) + " steps"); break;
            case MoveRouteActions.MOVE_UPPER_LEFT: ds_list_add(list.entries, "Move Upper Left: " + string(data[@ 1]) + " steps"); break;
            case MoveRouteActions.MOVE_UPPER_RIGHT: ds_list_add(list.entries, "Move Upper Right: " + string(data[@ 1]) + " steps"); break;
            case MoveRouteActions.MOVE_RANDOM: ds_list_add(list.entries, "Move Randomly"); break;
            case MoveRouteActions.MOVE_TOWARDS_PLAYER: ds_list_add(list.entries, "Move Towards"); break;
            case MoveRouteActions.MOVE_AWAY_PLAYER: ds_list_add(list.entries, "Move Away"); break;
            case MoveRouteActions.MOVE_FORWARD: ds_list_add(list.entries, "Move Forward"); break;
            case MoveRouteActions.MOVE_BACKWARD: ds_list_add(list.entries, "Move Backward"); break;
            case MoveRouteActions.MOVE_JUMP: ds_list_add(list.entries, data[@ 1] + " @ " + string(data[@ 2]) + ", " + string(data[@ 3]) + ", " + string(data[@ 4])); break;
            case MoveRouteActions.MOVE_ACTUALLY_JUMP: ds_list_add(list.entries, "Jump: " + string(data[@ 1]) + " cells/sec"); break;
            case MoveRouteActions.MOVE_TO: ds_list_add(list.entries, "To: " + string(data[@ 1]) + ", " + string(data[@ 2])); break;
            case MoveRouteActions.WAIT: ds_list_add(list.entries, "Wait for: " + string(data[@ 1]) + " seconds"); break;
            // column 2
            case MoveRouteActions.TURN_DOWN: ds_list_add(list.entries, "Turn Down"); break;
            case MoveRouteActions.TURN_LEFT: ds_list_add(list.entries, "Turn Left"); break;
            case MoveRouteActions.TURN_RIGHT: ds_list_add(list.entries, "Turn Right"); break;
            case MoveRouteActions.TURN_UP: ds_list_add(list.entries, "Turn Up"); break;
            case MoveRouteActions.TURN_90_RIGHT: ds_list_add(list.entries, "Turn 90° Right"); break;
            case MoveRouteActions.TURN_90_LEFT: ds_list_add(list.entries, "Turn 90° Left"); break;
            case MoveRouteActions.TURN_180: ds_list_add(list.entries, "About Face"); break;
            case MoveRouteActions.TURN_90_RANDOM: ds_list_add(list.entries, "Turn Left or Right"); break;
            case MoveRouteActions.TURN_RANDOM: ds_list_add(list.entries, "Turn Randomly"); break;
            case MoveRouteActions.TURN_TOWARD_PLAYER: ds_list_add(list.entries, "Turn Towards"); break;
            case MoveRouteActions.TURN_AWAY_PLAYER: ds_list_add(list.entries, "Turn Away"); break;
            // column 3
            case MoveRouteActions.SWITCH_ON: ds_list_add(list.entries, "Switch On: " + string(data[@ 1])); break;
            case MoveRouteActions.SWITCH_OFF: ds_list_add(list.entries, "Switch Off: " + string(data[@ 1])); break;
            case MoveRouteActions.CHANGE_SPEED: ds_list_add(list.entries, "Move Speed: " + string(data[@ 1])); break;
            case MoveRouteActions.CHANGE_FREQUENCY: ds_list_add(list.entries, "Move Frequency: " + string(data[@ 1])); break;
            case MoveRouteActions.WALKING_ANIM_ON: ds_list_add(list.entries, "Walk Animation: On"); break;
            case MoveRouteActions.WALKING_ANIM_OFF: ds_list_add(list.entries, "Walk Animation: Off"); break;
            case MoveRouteActions.STEPPING_ANIM_ON: ds_list_add(list.entries, "Step Animation: On"); break;
            case MoveRouteActions.STEPPING_ANIM_OFF: ds_list_add(list.entries, "Step Animation: Off"); break;
            case MoveRouteActions.DIRECTION_FIX_ON: ds_list_add(list.entries, "Direction Fix: On"); break;
            case MoveRouteActions.DIRECTION_FIX_OFF: ds_list_add(list.entries, "Direction Fix: Off"); break;
            case MoveRouteActions.SOLID_ON: ds_list_add(list.entries, "Solid: On"); break;
            case MoveRouteActions.SOLID_OFF: ds_list_add(list.entries, "Solid: Off"); break;
            case MoveRouteActions.TRANSPARENT_ON: ds_list_add(list.entries, "Transparency: On"); break;
            case MoveRouteActions.TRANSPARENT_OFF: ds_list_add(list.entries, "Transparency: Off"); break;
            // show the name once graphic list is implemented
            case MoveRouteActions.CHANGE_GRAPHIC: ds_list_add(list.entries, "Graphic: <name>"); break;
            case MoveRouteActions.CHANGE_OPACITY: ds_list_add(list.entries, "Opacity: "+string(data[@ 1])); break;
            // color - not displayable
            case MoveRouteActions.CHANGE_TINT: ds_list_add(list.entries, "Tint..."); break;
            // show the name once sound effect list is implemented
            case MoveRouteActions.PLAY_SE: ds_list_add(list.entries, "Sound: <name>"); break;
            case MoveRouteActions.EVENT:
                var event = guid_get(data[@ 1]);
                var entrypoint = guid_get(data[@ 2]);
                if (!event || !entrypoint) {
                    ds_list_add(list.entries, "Event: N/A");
                } else {
                    ds_list_add(list.entries, "Event: " + event.name + "/" + entrypoint.name);
                }
                break;
        }
    }

    ui_render_list(list, argument1, argument2);

    list.text = otext;


}
