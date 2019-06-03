/// @description void ui_render_list_move_route_steps(UIList);
/// @param UIList

var steps=argument0.root.route.steps;
var otext=argument0.text;
argument0.text=argument0.text+string(ds_list_size(steps));
argument0.colorize=false;

ds_list_clear(argument0.entries);

for (var i=0; i<ds_list_size(steps); i++) {
    var data=steps[| i];
    switch (data[@ 0]) {
        case MoveRouteActions.MOVE_DOWN:
            ds_list_add(argument0.entries, "Move Down: "+string(data[@ 1])+" steps");
            break;
        case MoveRouteActions.MOVE_UP:
            ds_list_add(argument0.entries, "Move Up: "+string(data[@ 1])+" steps");
            break;
        case MoveRouteActions.MOVE_LEFT:
            ds_list_add(argument0.entries, "Move Left: "+string(data[@ 1])+" steps");
            break;
        case MoveRouteActions.MOVE_RIGHT:
            ds_list_add(argument0.entries, "Move Right: "+string(data[@ 1])+" steps");
            break;
        case MoveRouteActions.MOVE_LOWER_LEFT:
            ds_list_add(argument0.entries, "Move Lower Left: "+string(data[@ 1])+" steps");
            break;
        case MoveRouteActions.MOVE_LOWER_RIGHT:
            ds_list_add(argument0.entries, "Move Lower Right: "+string(data[@ 1])+" steps");
            break;
        case MoveRouteActions.MOVE_UPPER_LEFT:
            ds_list_add(argument0.entries, "Move Upper Left: "+string(data[@ 1])+" steps");
            break;
        case MoveRouteActions.MOVE_UPPER_RIGHT:
            ds_list_add(argument0.entries, "Move Upper Right: "+string(data[@ 1])+" steps");
            break;
        case MoveRouteActions.MOVE_RANDOM:
            ds_list_add(argument0.entries, "Move Randomly");
            break;
        case MoveRouteActions.MOVE_TOWARDS_PLAYER:
            ds_list_add(argument0.entries, "Move Towards");
            break;
        case MoveRouteActions.MOVE_AWAY_PLAYER:
            ds_list_add(argument0.entries, "Move Away");
            break;
        case MoveRouteActions.MOVE_FORWARD:
            ds_list_add(argument0.entries, "Move Forward");
            break;
        case MoveRouteActions.MOVE_BACKWARD:
            ds_list_add(argument0.entries, "Move Backward");
            break;
        case MoveRouteActions.MOVE_JUMP:
            ds_list_add(argument0.entries, data[@ 1]+" @ "+string(data[@ 2])+", "+string(data[@ 3])+", "+string(data[@ 4]));
            break;
        case MoveRouteActions.MOVE_ACTUALLY_JUMP:
            ds_list_add(argument0.entries, "Jump: "+string(data[@ 1])+" cells/sec");
            break;
        case MoveRouteActions.MOVE_TO:
            ds_list_add(argument0.entries, "To: "+string(data[@ 1])+", "+string(data[@ 2]));
            break;
        case MoveRouteActions.WAIT:
            ds_list_add(argument0.entries, "Wait for: "+string(data[@ 1])+" seconds");
            break;
        // column 2
        case MoveRouteActions.TURN_DOWN:
            ds_list_add(argument0.entries, "Turn Down");
            break;
        case MoveRouteActions.TURN_LEFT:
            ds_list_add(argument0.entries, "Turn Left");
            break;
        case MoveRouteActions.TURN_RIGHT:
            ds_list_add(argument0.entries, "Turn Right");
            break;
        case MoveRouteActions.TURN_UP:
            ds_list_add(argument0.entries, "Turn Up");
            break;
        case MoveRouteActions.TURN_90_RIGHT:
            ds_list_add(argument0.entries, "Turn 90° Right");
            break;
        case MoveRouteActions.TURN_90_LEFT:
            ds_list_add(argument0.entries, "Turn 90° Left");
            break;
        case MoveRouteActions.TURN_180:
            ds_list_add(argument0.entries, "About Face");
            break;
        case MoveRouteActions.TURN_90_RANDOM:
            ds_list_add(argument0.entries, "Turn Left or Right");
            break;
        case MoveRouteActions.TURN_RANDOM:
            ds_list_add(argument0.entries, "Turn Randomly");
            break;
        case MoveRouteActions.TURN_TOWARD_PLAYER:
            ds_list_add(argument0.entries, "Turn Towards");
            break;
        case MoveRouteActions.TURN_AWAY_PLAYER:
            ds_list_add(argument0.entries, "Turn Away");
            break;
        // column 3
        case MoveRouteActions.SWITCH_ON:
            ds_list_add(argument0.entries, "Switch On: "+string(data[@ 1]));
            break;
        case MoveRouteActions.SWITCH_OFF:
            ds_list_add(argument0.entries, "Switch Off: "+string(data[@ 1]));
            break;
        case MoveRouteActions.CHANGE_SPEED:
            ds_list_add(argument0.entries, "Move Speed: "+string(data[@ 1]));
            break;
        case MoveRouteActions.CHANGE_FREQUENCY:
            ds_list_add(argument0.entries, "Move Frequency: "+string(data[@ 1]));
            break;
        case MoveRouteActions.WALKING_ANIM_ON:
            ds_list_add(argument0.entries, "Walk Animation: On");
            break;
        case MoveRouteActions.WALKING_ANIM_OFF:
            ds_list_add(argument0.entries, "Walk Animation: Off");
            break;
        case MoveRouteActions.STEPPING_ANIM_ON:
            ds_list_add(argument0.entries, "Step Animation: On");
            break;
        case MoveRouteActions.STEPPING_ANIM_OFF:
            ds_list_add(argument0.entries, "Step Animation: Off");
            break;
        case MoveRouteActions.DIRECTION_FIX_ON:
            ds_list_add(argument0.entries, "Direction Fix: On");
            break;
        case MoveRouteActions.DIRECTION_FIX_OFF:
            ds_list_add(argument0.entries, "Direction Fix: Off");
            break;
        case MoveRouteActions.SOLID_ON:
            ds_list_add(argument0.entries, "Solid: On");
            break;
        case MoveRouteActions.SOLID_OFF:
            ds_list_add(argument0.entries, "Solid: Off");
            break;
        case MoveRouteActions.TRANSPARENT_ON:
            ds_list_add(argument0.entries, "Transparency: On");
            break;
        case MoveRouteActions.TRANSPARENT_OFF:
            ds_list_add(argument0.entries, "Transparency: Off");
            break;
        case MoveRouteActions.CHANGE_GRAPHIC:
            // show the name once graphic list is implemented
            ds_list_add(argument0.entries, "Graphic: <name>");
            break;
        case MoveRouteActions.CHANGE_OPACITY:
            ds_list_add(argument0.entries, "Opacity: "+string(data[@ 1]));
            break;
        case MoveRouteActions.CHANGE_TINT:
            ds_list_add(argument0.entries, "Tint...");       // color - not displayable
            break;
        case MoveRouteActions.PLAY_SE:
            // show the name once sound effect list is implemented
            ds_list_add(argument0.entries, "Sound: <name>");
            break;
        case MoveRouteActions.EVENT:
            var event=guid_get(data[@ 1]);
            var entrypoint=guid_get(data[@ 2]);
            if (event==noone||entrypoint==noone) {
                ds_list_add(argument0.entries, "Event: N/A");
            } else {
                ds_list_add(argument0.entries, "Event: "+event.name+"/"+entrypoint.name);
            }
            break;
    }
}

ui_render_list(argument0, argument1, argument2);

argument0.text=otext;
