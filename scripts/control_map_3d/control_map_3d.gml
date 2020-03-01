/// @param EditorModeMap

var mode = argument0;
var input_control = keyboard_check(vk_control);

if (Stuff.menu.active_element) {
    return false;
}

var mouse_vector = update_mouse_vector(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup, mode.fov, CW / CH);

var xx = mouse_vector[vec3.xx] * MILLION;
var yy = mouse_vector[vec3.yy] * MILLION;
var zz = mouse_vector[vec3.zz] * MILLION;

// stash the result because you may hit a special value of some type
if (c_raycast_world(mode.x, mode.y, mode.z, mode.x + xx, mode.y + yy, mode.z + zz, Controller.mouse_pick_mask)) {
    var instance_under_cursor = c_object_get_userid(c_hit_object(0));
} else {
    var instance_under_cursor = noone;
}

var floor_x = -1;
var floor_y = -1;
var floor_z = -1;
var floor_cx = -1;
var floor_cy = -1;
var floor_cz = -1;

if (!mode.mouse_over_ui) {
    // in case you want to kick out of the interaction processing
    var process_main = true;
    
    #region general inputs (click-and-drag things)
    if (instanceof(instance_under_cursor, ComponentData)) {
        // check mouse down
        if (Controller.press_left) {
            script_execute(instance_under_cursor.on_mouse_down, instance_under_cursor);
            Controller.mouse_pick_mask = CollisionMasks.AXES;
            Controller.mouse_hit_previous = [c_hit_x(), c_hit_y(), c_hit_z()];
        }
        // check mouse hold
        if (Controller.mouse_left) {
            if (Controller.mouse_hit_previous != undefined) {
                var delta = script_execute(instance_under_cursor.on_mouse_stay, instance_under_cursor);
            }
        }
        // check mouse release
        if (Controller.release_left) {
            if (Controller.mouse_hit_previous != undefined) {
                script_execute(instance_under_cursor.on_mouse_up, instance_under_cursor);
                Controller.mouse_hit_previous = undefined;
            }
        }
        // anything on hover
        script_execute(instance_under_cursor.on_mouse_hover, instance_under_cursor);
        // discard the data and don't set the persistent under cursor value
        instance_under_cursor = noone;
        process_main = false;
    } else {
        // this is bad code but should catch all cases where you want to reset the mouse picking mask
        Controller.mouse_pick_mask = CollisionMasks.MAIN;
    }
    #endregion
    
    if (process_main) {
        // it makes no sense to check where the mouse vector intersects with the floor if you're not looking down
        if (zz < mode.z) {
            var f = abs((mode.z - (mode.edit_z * TILE_DEPTH)) / zz);
            floor_x = mode.x + xx * f;
            floor_y = mode.y + yy * f;
            floor_z = mode.edit_z * TILE_DEPTH;
            
            // the bounds on this are weird - in some places the cell needs to be rounded up and in others it
            // needs to be rounded down, so the minimum allowed "cell" is (-1, -1) - be sure to max() this later
            // if it would cause issues
            floor_cx = clamp(floor_x div TILE_WIDTH, -1, mode.active_map.xx - 1);
            floor_cy = clamp(floor_y div TILE_HEIGHT, -1, mode.active_map.yy - 1);
            floor_cz = clamp(floor_z div TILE_DEPTH, -1, mode.active_map.zz - 1);
            
            if (Controller.press_left) {
                if (ds_list_size(mode.selection) < MAX_SELECTION_COUNT) {
                    if (!keyboard_check(Controller.input_selection_add) && !Stuff.setting_selection_addition) {
                        selection_clear();
                    }
                    switch (Stuff.setting_selection_mode) {
                        case SelectionModes.SINGLE: var stype = SelectionSingle; break;
                        case SelectionModes.RECTANGLE: var stype = SelectionRectangle; break;
                        case SelectionModes.CIRCLE: var stype = SelectionCircle; break;
                        // not sure why it broke once, but just in case
                        default: Stuff.setting_selection_mode = SelectionModes.RECTANGLE; var stype = SelectionRectangle; break;
                    }
                    
                    var button = Stuff.map.ui.t_p_other.el_zone_data;
                    button.text = "Zone Data";
                    button.interactive = false;
                    button.onmouseup = null;
                    mode.selected_zone = noone;
                    
                    var tz = instance_under_cursor ? max(instance_under_cursor.zz, mode.edit_z) : mode.edit_z;
                    
                    if (instance_under_cursor && instanceof(instance_under_cursor, DataCameraZone)) {
                        button.interactive = true;
                        button.onmouseup = instance_under_cursor.zone_edit_script;
                        button.text = "Data: " + instance_under_cursor.name;
                        mode.selected_zone = instance_under_cursor;
                    } else {
                        mode.last_selection = selection_add(stype, max(0, floor_cx), max(0, floor_cy), tz);
                    }
                }
            }
            
            if (Controller.mouse_left) {
                if (mode.last_selection) {
                    script_execute(mode.last_selection.onmousedrag, mode.last_selection, floor_cx + 1, floor_cy + 1);
                }
            }
            
            if (Controller.release_left) {
                // selections of zero area are just deleted outright
                if (mode.last_selection) {
                    if (script_execute(mode.last_selection.area, mode.last_selection) == 0) {
                        instance_activate_object(mode.last_selection);
                        instance_destroy(mode.last_selection);
                        ds_list_pop(mode.selection);
                        mode.last_selection = noone;
                    }
                    sa_process_selection();
                }
            }
            
            if (Controller.press_right) {
                Controller.press_right = false;
                // if there is no selection, select the single square under the cursor. Otherwise you might
                // want to do operations on large swaths of entities, so don't clear it or anythign like that.
            
                if (selection_empty()) {
                    var tz = instance_under_cursor ? instance_under_cursor.zz : 0;
                    mode.last_selection = instance_create_depth(0, 0, 0, SelectionSingle);
                    ds_list_add(mode.selection, mode.last_selection);
                    script_execute(mode.last_selection.onmousedown, mode.last_selection, floor_cx, floor_cy, tz);
                }
                
                var menu = Stuff.menu.menu_right_click;
                menu_activate_extra(menu);
                menu.x = Stuff.MOUSE_X;
                menu.y = Stuff.MOUSE_Y;
            }
        }
    }
        
    if (!input_control) {
        if (keyboard_check_pressed(vk_space)) {
            sa_fill();
        }
        if (keyboard_check_pressed(vk_delete)) {
            sa_delete();
        }
    }
    
    // move the camera
    
    if (CONTORL_3D_LOOK || !input_control) {
        var mspd = get_camera_speed(mode.z)
        var xspeed = 0;
        var yspeed = 0;
        var zspeed = 0;
    
        if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
            xspeed = xspeed + dcos(mode.direction) * mspd;
            yspeed = yspeed - dsin(mode.direction) * mspd;
            zspeed = zspeed - dsin(mode.pitch) * mspd;
        }
        if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
            xspeed = xspeed - dcos(mode.direction) * mspd;
            yspeed = yspeed + dsin(mode.direction) * mspd;
            zspeed = zspeed + dsin(mode.pitch) * mspd;
        }
        if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
            xspeed = xspeed - dsin(mode.direction) * mspd;
            yspeed = yspeed - dcos(mode.direction) * mspd;
        }
        if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
            xspeed = xspeed + dsin(mode.direction) * mspd;
            yspeed = yspeed + dcos(mode.direction) * mspd;
        }
        if (CONTORL_3D_LOOK) {
            var camera_cx = view_get_xport(view_3d) + view_get_wport(view_3d) / 2;
            var camera_cy = view_get_yport(view_3d) + view_get_hport(view_3d) / 2;
            var dx = (Stuff.MOUSE_X - camera_cx) / 16;
            var dy = (Stuff.MOUSE_Y - camera_cy) / 16;
            mode.direction = (360 + mode.direction - dx) % 360;
            mode.pitch = clamp(mode.pitch + dy, -89, 89);
            window_mouse_set(camera_cx, camera_cy);
            mode.xto = mode.x + dcos(mode.direction);
            mode.yto = mode.y - dsin(mode.direction);
            mode.zto = mode.z - dsin(mode.pitch);
        }
    
        mode.x += xspeed;
        mode.y += yspeed;
        mode.z += zspeed;
        mode.xto += xspeed;
        mode.yto += yspeed;
        mode.zto += zspeed;
        mode.xup = 0;
        mode.yup = 0;
        mode.zup = 1;
    }
}

mode.mouse_over_ui = false;
mode.under_cursor = instance_under_cursor ? instance_under_cursor : mode.under_cursor;