function dialog_exists() {
    return !ds_list_empty(Stuff.dialogs) || !ds_list_empty(EmuOverlay._contents);
}

function dialog_create(width, height, text, render = dialog_default, commit = dialog_destroy, root = undefined, close = dialog_destroy) {
    var base_x = 64;
    var base_y = 64;
    var offset = 48;
    var n = ds_list_size(Stuff.dialogs);
    
    var dg = instance_create_depth(base_x + n * offset, base_y + n * offset, 0, Dialog);
    dg.width = width;
    dg.height = height;
    dg.text = text;
    dg.render = render;
    dg.commit = commit;
    dg.root = root;
    // "close" can be set to undefined if you want to hide the button entirely
    dg.close = close;
    
    ds_list_add(Stuff.dialogs, dg);
    instance_deactivate_object(dg);
    
    return dg;
}

function dialog_destroy() {
    // closes the top dialog. or schedules it for closing. if you
    // destroy it now, bad things will happen to other parts of the
    // Draw event which still reference it, because my code is spaghetti.
    if (dialog_exists()) {
        instance_destroy_later(Stuff.dialogs[| ds_list_size(Stuff.dialogs) - 1]);
        ds_list_delete(Stuff.dialogs, ds_list_size(Stuff.dialogs) - 1);
    }
}

function dialog_is_active(dialog) {
    // this assumes that if there are no active dialog windows, any
    // active ui elements live in a Free Parking part of the window.
    if (EmuOverlay.GetTop()) return false;
    if (ds_list_empty(Stuff.dialogs)) return true;
    return (ds_list_top(Stuff.dialogs) == dialog);
}

function dialog_default(dialog) {
    var header_height = 32;
    var x1 = dialog.x;
    var y1 = dialog.y;
    var x2 = x1 + dialog.width;
    var y2 = y1 + dialog.height;
    
    var active = dialog_is_active(dialog);
    var kill = false;
    
    var tx = x1 + 32;
    var ty = y1 + header_height / 2;
    
    var cbs = sprite_get_width(spr_close) / 2;
    var cbx = x2 - cbs;
    var cby = ty;
    var cbi = 2;  // 0 is is available, 1 is hovering, 2 is unavailable
    
    // move the box first
    if (active) {
        cbi = 0;
        if (mouse_within_rectangle(x1, y1, x2, y1 + header_height)) {
            // close box
            var cbx1 = cbx - cbs;
            var cby1 = cby - cbs;
            var cbx2 = cbx + cbs;
            var cby2 = cby + cbs;
            if (mouse_within_rectangle(cbx1, cby1, cbx2, cby2)) {
                cbi = 1;
                if (!(dialog.flags & DialogFlags.NO_CLOSE_BUTTON) && Controller.release_left) {
                    kill = true;
                }
            } else {
                // dragging things around
                if (Controller.press_left) {
                    dialog.cmx = mouse_x;
                    dialog.cmy = mouse_y;
                }
                if (Controller.release_left) {
                    dialog.cmx = -1;
                    dialog.cmy = -1;
                }
            }
        }
        
        if (Controller.mouse_left && dialog.cmx > -1) {
            var dx = mouse_x - dialog.cmx;
            var dy = mouse_y - dialog.cmy;
            dialog.x = dialog.x + dx;
            dialog.y = dialog.y + dy;
            dialog.cmx = mouse_x;
            dialog.cmy = mouse_y;
        }
        
        if (device_mouse_check_button_released(0, mb_left)) {
            self.contents_interactive = true;
        }
    }
    
    // re-set these in case you dragged the window around, in which case they got moved
    x1 = dialog.x;
    y1 = dialog.y;
    x2 = x1 + dialog.width;
    y2 = y1 + dialog.height;
    
    tx = x1 + 32;
    ty = y1 + header_height / 2;
    
    if (active && dialog.active_shade && !Stuff.drawn_dialog_shade) {
        draw_set_alpha(Settings.config.focus_alpha);
        draw_rectangle_colour(0, 0, window_get_width(), window_get_height(), c_black, c_black, c_black, c_black, false);
        draw_set_alpha(1);
        Stuff.drawn_dialog_shade = true;
    }
    
    // NOW you're allowed to draw stuff
    draw_rectangle_colour(x1, y1, x2, y2, c_white, c_white, c_white, c_white, false);
    draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);
    
    var hc = active ? Settings.colors.primary : merge_colour(Settings.colors.primary, c_white, 0.75);
    
    draw_rectangle_colour(x1, y1, x2, y1 + header_height, hc, hc, hc, hc, false);
    draw_line_colour(x1, y1 + header_height, x2, y1 + header_height, c_black, c_black);
    
    draw_set_halign(fa_left);
    draw_text_colour(tx, ty, string(dialog.text), c_black, c_black, c_black, c_black, 1);
    
    if (!(dialog.flags & DialogFlags.NO_CLOSE_BUTTON) && dialog.close) {
        draw_sprite(spr_close, cbi, cbx, cby);
    }
    
    for (var i = 0; i < ds_list_size(dialog.contents); i++) {
        var thing = dialog.contents[| i];
        if (thing.enabled) {
            if (is_struct(thing)) {
                thing.Render(dialog.x, dialog.y); 
            } else {
                thing.render(thing, dialog.x, dialog.y); 
            }
        }
    }
    
    try {
        // do this at the end in case some inner element needs to use the escape key
        kill |= (active && Controller.release_escape && (!Stuff.mode.ui.active_element || !Stuff.mode.ui.active_element.override_escape));
    } catch (e) {
        wtf("deal with later, maybe");
        wtf(e.longMessage);
        wtf(e.stacktrace);
    }
    
    // the x button/escape key does not commit changes
    if (kill && dialog.close) {
        dialog.close();
    }
}

function dialog_note_changes(dialog) {
    var old_title = dialog.text;
    if (dialog.changed) dialog.text = "* " + dialog.text;
    dialog_default(dialog);
    dialog.text = old_title;
}

function dmu_dialog_cancel() {
    dialog_destroy();
}

function dmu_dialog_commit(thing) {
    thing.root.commit(thing.root);
}