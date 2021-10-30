/// @param EditorModeMap
function control_map(mode) {
    var map = mode.active_map;
    var map_contents = map.contents;
    var input_control = keyboard_check(vk_control);
    var camera = view_get_camera(view_3d);
    
    if (Stuff.menu.active_element) return;
    
    #region mouse picking
    var rc_xfrom, rc_yfrom, rc_zfrom, rc_xto, rc_yto, rc_zto;
    var xx, yy, zz, xadjust, yadjust, zadjust;
    if (Settings.view.threed) {
        var mouse_vector = screen_to_world(window_mouse_get_x(), window_mouse_get_y(),
            matrix_build_lookat(mode.x, mode.y, mode.z, mode.xto, mode.yto, mode.zto, mode.xup, mode.yup, mode.zup),
            matrix_build_projection_perspective_fov(mode.fov, CW / CH, 1, 1000),
            CW, CH
        );
        
        // end point of the mouse vector
        xx = mouse_vector[vec3.xx] * MILLION;
        yy = mouse_vector[vec3.yy] * MILLION;
        zz = mouse_vector[vec3.zz] * MILLION;
        
        // raycast coordinates
        rc_xfrom = mode.x;
        rc_yfrom = mode.y;
        rc_zfrom = mode.z;
        rc_xto = mode.x + xx;
        rc_yto = mode.y + yy;
        rc_zto = mode.z + zz;
        
        // you only need this in 2D
        xadjust = 0;
        yadjust = 0;
        zadjust = 0;
    } else {
        var cwidth = camera_get_view_width(camera);
        var cheight = camera_get_view_height(camera);
        
        // mouse vector (in 2D you always go straight down)
        xx = 0;
        yy = 0;
        zz = -1;
        
        // raycast coordinates
        rc_xfrom = mode.x + ((mouse_x_view - cwidth / 2) / view_get_wport(view_3d)) * cwidth;
        rc_yfrom = mode.y + ((mouse_y_view - cheight / 2) / view_get_hport(view_3d)) * cheight;
        rc_zfrom = MILLION;
        rc_xto = rc_xfrom;
        rc_yto = rc_yfrom;
        rc_zto = -1;
        
        // offset from the center of the screen
        xadjust = rc_xfrom - mode.x;
        yadjust = rc_yfrom - mode.y;
        zadjust = -MILLION;
    }
    
    var instance_under_cursor = undefined;
    // stash the result because you may hit a special value of some type
    if (c_raycast_world(rc_xfrom, rc_yfrom, rc_zfrom, rc_xto, rc_yto, rc_zto, Controller.mouse_pick_mask)) {
        instance_under_cursor = c_object_get_userid(c_hit_object(0)) ?? BulletUserIDCollection.Get(instance_under_cursor);
    }
    #endregion
    
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
        if (instance_under_cursor && instance_under_cursor.is_component) {
            // check mouse down
            if (Controller.press_left) {
                instance_under_cursor.on_mouse_down(instance_under_cursor);
                Controller.mouse_pick_mask = CollisionMasks.AXES;
                Controller.mouse_hit_previous = [c_hit_x(), c_hit_y(), c_hit_z()];
            }
            // check mouse hold
            if (Controller.mouse_left) {
                if (Controller.mouse_hit_previous != undefined) {
                    var delta = instance_under_cursor.on_mouse_stay(instance_under_cursor);
                }
            }
            // check mouse release
            if (Controller.release_left) {
                if (Controller.mouse_hit_previous != undefined) {
                    instance_under_cursor.on_mouse_up(instance_under_cursor);
                    Controller.mouse_hit_previous = undefined;
                }
            }
            // anything on hover
            instance_under_cursor.on_mouse_hover(instance_under_cursor);
            // discard the data and don't set the persistent under cursor value
            instance_under_cursor = noone;
            process_main = false;
        } else {
            // this is bad code but should catch all cases where you want to reset the mouse picking mask
            Controller.mouse_pick_mask = CollisionMasks.MAIN;
        }
        #endregion
        
        #region process the stuff you clicked on
        if (process_main) {
            // it makes no sense to check where the mouse vector intersects with the
            // floor if you're not looking down
            if (zz < mode.z) {
                var f = abs((mode.z - (mode.edit_z * TILE_DEPTH)) / zz);
                
                floor_x = mode.x + xx * f + xadjust;
                floor_y = mode.y + yy * f + yadjust;
                floor_z = mode.edit_z * TILE_DEPTH + zadjust;
                
                // the bounds on this are weird - in some places the cell needs to be
                // rounded up and in others it needs to be rounded down, so the minimum
                // allowed "cell" is (-1, -1) - be sure to max() this later if it
                // would cause issues
                floor_cx = clamp(floor_x div TILE_WIDTH, -1, mode.active_map.xx - 1);
                floor_cy = clamp(floor_y div TILE_HEIGHT, -1, mode.active_map.yy - 1);
                floor_cz = clamp(floor_z div TILE_DEPTH, -1, mode.active_map.zz - 1);
                
                if (Controller.press_left) {
                    if (array_length(mode.selection) < MAX_SELECTION_COUNT) {
                        if (!keyboard_check(Controller.input_selection_add) && !Settings.selection.addition) {
                            selection_clear();
                        }
                        var stype = SelectionRectangle;
                        switch (Settings.selection.mode) {
                            case SelectionModes.SINGLE: stype = SelectionSingle; break;
                            case SelectionModes.RECTANGLE: stype = SelectionRectangle; break;
                            case SelectionModes.CIRCLE: stype = SelectionCircle; break;
                        }
                        
                        var button = Stuff.map.ui.t_p_other.el_zone_data;
                        button.text = "Zone Data";
                        button.interactive = false;
                        button.onmouseup = null;
                        mode.selected_zone = noone;
                        
                        var tz = instance_under_cursor ? max(instance_under_cursor.zz, mode.edit_z) : mode.edit_z;
                        
                        if (instance_under_cursor && instance_under_cursor.ztype != undefined) {
                            button.interactive = true;
                            button.onmouseup = instance_under_cursor.EditScript;
                            button.text = "Data: " + instance_under_cursor.name;
                            mode.selected_zone = instance_under_cursor;
                        } else {
                            mode.last_selection = new stype(max(0, floor_cx), max(0, floor_cy), tz);
                        }
                    }
                }
                
                if (Controller.mouse_left) {
                    if (mode.last_selection) {
                        mode.last_selection.onmousedrag(floor_cx + 1, floor_cy + 1);
                    }
                }
                
                if (Controller.release_left) {
                    // selections of zero area are just deleted outright
                    if (mode.last_selection) {
                        if (mode.last_selection.area() == 0) {
                            array_pop(mode.selection);
                            mode.last_selection = undefined;
                        }
                        sa_process_selection();
                    }
                }
                
                if (Controller.press_right) {
                    Controller.press_right = false;
                    // if there is no selection, select the single square under the
                    // cursor. Otherwise you might want to do operations on large
                    // swaths of entities, so don't clear it or anythign like that.
                    
                    if (selection_empty()) {
                        mode.last_selection = new SelectionSingle(floor_cx, floor_cy, instance_under_cursor ? instance_under_cursor.zz : 0);
                    }
                    
                    var menu = Stuff.menu.menu_right_click;
                    menu_activate_extra(menu);
                    menu.x = mouse_x;
                    menu.y = mouse_y;
                }
            }
        }
        #endregion
        
        #region main map editing actions
        if (!input_control) {
            if (keyboard_check_pressed(vk_space)) {
                sa_fill();
            }
            if (keyboard_check_pressed(vk_delete)) {
                sa_delete();
            }
        }
        #endregion
        
        #region camera movement
        if (CONTROL_3D_LOOK || !input_control) {
            var mspd = get_camera_speed(Settings.view.threed ? mode.z : 100);
            var xspeed = 0;
            var yspeed = 0;
            var zspeed = 0;
            var xup = 0;
            var yup = 0;
            var zup = 0;
            
            if (Settings.view.threed) {
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
                if (CONTROL_3D_LOOK) {
                    var camera_cx = view_get_xport(view_3d) + view_get_wport(view_3d) div 2;
                    var camera_cy = view_get_yport(view_3d) + view_get_hport(view_3d) div 2;
                    var dx = (mouse_x - camera_cx) / 16;
                    var dy = (mouse_y - camera_cy) / 16;
                    mode.direction = (360 + mode.direction - dx) % 360;
                    mode.pitch = clamp(mode.pitch + dy, -89, 89);
                    window_mouse_set(camera_cx, camera_cy);
                    mode.xto = mode.x + dcos(mode.direction) * dcos(mode.pitch);
                    mode.yto = mode.y - dsin(mode.direction) * dcos(mode.pitch);
                    mode.zto = mode.z - dsin(mode.pitch);
                }
                
                xup = 0;
                yup = 0;
                zup = 1;
            } else {
                xup = 0;
                yup = -1;
                zup = 0;
                
                if (keyboard_check(vk_up) || keyboard_check(ord("W"))) {
                    yspeed = yspeed - mspd;
                }
                if (keyboard_check(vk_down) || keyboard_check(ord("S"))) {
                    yspeed = yspeed + mspd;
                }
                if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
                    xspeed = xspeed - mspd;
                }
                if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
                    xspeed = xspeed + mspd;
                }
                if (CONTROL_3D_LOOK) {
                    var camera_cx = view_get_xport(view_3d) + view_get_wport(view_3d) div 2;
                    var camera_cy = view_get_yport(view_3d) + view_get_hport(view_3d) div 2;
                    xspeed = (mouse_x - camera_cx);
                    yspeed = (mouse_y - camera_cy);
                    window_mouse_set(camera_cx, camera_cy);
                }
            }
            
            mode.x += xspeed;
            mode.y += yspeed;
            mode.z += zspeed;
            mode.xto += xspeed;
            mode.yto += yspeed;
            mode.zto += zspeed;
            mode.xup = xup;
            mode.yup = yup;
            mode.zup = zup;
        }
        #endregion
    }
    
    mode.mouse_over_ui = false;
    mode.under_cursor = instance_under_cursor ? instance_under_cursor : mode.under_cursor;
}