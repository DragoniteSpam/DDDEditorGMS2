function control_map() {
    var mode = Stuff.map;
    var map = mode.active_map;
    var map_contents = map.contents;
    var input_control = keyboard_check(vk_control);
    
    if (Stuff.menu.active_element || !ds_list_empty(EmuOverlay._contents)) return;
    
    var instance_under_cursor = undefined;
    /*
    #region mouse picking
    
    /// @todo implement raycast into the world, maybe
    #endregion
    
    var floor_x = -1;
    var floor_y = -1;
    var floor_z = -1;
    var floor_cx = -1;
    var floor_cy = -1;
    var floor_cz = -1;
    */
    if (!mode.mouse_over_ui) {
        /*
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
        */
        #region camera movement
        if (CONTROL_3D_LOOK || !input_control) {
            var mspd = get_camera_speed(Settings.view.threed ? mode.camera.z : 100);
            var xspeed = 0;
            var yspeed = 0;
            var zspeed = 0;
            var xup = 0;
            var yup = 0;
            var zup = 0;
            
            if (Settings.view.threed) {
                mode.camera.Update();
            } else {
                mode.camera.UpdateOrtho();
            }
        }
        #endregion
    }
    
    mode.mouse_over_ui = false;
    mode.under_cursor = instance_under_cursor ? instance_under_cursor : mode.under_cursor;
}