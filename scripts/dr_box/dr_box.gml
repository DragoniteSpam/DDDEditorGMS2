/// @param Dialog
function dr_box(argument0) {

	var header_height = 32;

	var dialog = argument0;
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
	    if (mouse_within_rectangle_determine(x1, y1, x2, y1 + header_height, true)) {
	        // close box
	        var cbx1 = cbx - cbs;
	        var cby1 = cby - cbs;
	        var cbx2 = cbx + cbs;
	        var cby2 = cby + cbs;
	        if (mouse_within_rectangle_determine(cbx1, cby1, cbx2, cby2, true)) {
	            cbi = 1;
	            if (!(dialog.dialog_flags & DialogFlags.NO_CLOSE_BUTTON) && Controller.release_left) {
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
	}

	// re-set these in case you dragged the window around, in which case they got moved
	var x1 = dialog.x;
	var y1 = dialog.y;
	var x2 = x1 + dialog.width;
	var y2 = y1 + dialog.height;

	var tx = x1 + 32;
	var ty = y1 + header_height / 2;

	if (active && dialog.active_shade && !Stuff.drawn_dialog_shade) {
	    draw_set_alpha(Stuff.setting_focus_alpha);
	    draw_rectangle_colour(0, 0, window_get_width(), window_get_height(), c_black, c_black, c_black, c_black, false);
	    draw_set_alpha(1);
	    Stuff.drawn_dialog_shade = true;
	}

	// NOW you're allowed to draw stuff
	draw_rectangle_colour(x1, y1, x2, y2, c_white, c_white, c_white, c_white, false);
	draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);

	var hc = active ? Stuff.setting_color : merge_colour(Stuff.setting_color, c_white, 0.75);

	draw_rectangle_colour(x1, y1, x2, y1 + header_height, hc, hc, hc, hc, false);
	draw_line_colour(x1, y1 + header_height, x2, y1 + header_height, c_black, c_black);

	draw_set_halign(fa_left);
	draw_text_colour(tx, ty, string(dialog.text), c_black, c_black, c_black, c_black, 1);

	if (!(dialog.dialog_flags & DialogFlags.NO_CLOSE_BUTTON) && dialog.close) {
	    draw_sprite(spr_close, cbi, cbx, cby);
	}

	for (var i = 0; i < ds_list_size(dialog.contents); i++) {
	    var thing = dialog.contents[| i];
	    if (thing.enabled) {
	        script_execute(thing.render, thing, dialog.x, dialog.y);
	    }
	}

	// do this at the end in case some inner element needs to use the escape key
	kill = kill || (active && Controller.release_escape && (!Stuff.mode.ui.active_element || !Stuff.mode.ui.active_element.override_escape));

	// the x button/escape key does not commit changes
	if (kill && dialog.close) {
	    script_execute(dialog.close, dialog);
	}


}
