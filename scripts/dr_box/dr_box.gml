/// @param Dialog

var header_height = 32;

var x1 = argument0.x;
var y1 = argument0.y;
var x2 = x1 + argument0.width;
var y2 = y1 + argument0.height;

var active = dialog_is_active(argument0);
var kill = false;

var tx = x1 + 32;
var ty = y1 + header_height / 2;

var cbs = sprite_get_width(spr_close) / 2;
var cbx = x2 - cbs;
var cby = ty;
var cbi = 2;  // 0 is is available, 1 is hovering, 2 is unavailable

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
            if (get_release_left()) {
                kill = true;
            }
        } else {
            // dragging things around
            if (Controller.press_left) {
                argument0.cmx = Camera.MOUSE_X;
                argument0.cmy = Camera.MOUSE_Y;
            }
            if (Controller.release_left) {
                argument0.cmx = -1;
                argument0.cmy = -1;
            }
        }
    }
    
    if (Controller.mouse_left && argument0.cmx > -1) {
        var dx = Camera.MOUSE_X - argument0.cmx;
        var dy = Camera.MOUSE_Y - argument0.cmy;
        argument0.x = argument0.x + dx;
        argument0.y = argument0.y + dy;
        argument0.cmx = Camera.MOUSE_X;
        argument0.cmy = Camera.MOUSE_Y;
    }
}

draw_rectangle_colour(x1, y1, x2, y2, c_white, c_white, c_white, c_white, false);
draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);

if (active) {
    var hc = Stuff.setting_color;
} else {
    var hc = merge_colour(Stuff.setting_color, c_white, 0.75);
}

draw_rectangle_colour(x1, y1, x2, y1 + header_height, hc, hc, hc, hc, false);
draw_line_colour(x1, y1 + header_height, x2, y1 + header_height, c_black, c_black);

draw_set_halign(fa_left);
draw_text(tx, ty, string(argument0.text));

draw_sprite(spr_close, cbi, cbx, cby);

for (var i = 0; i < ds_list_size(argument0.contents); i++) {
    var thing = argument0.contents[| i];
    if (thing.enabled) {
        script_execute(thing.render, thing, argument0.x, argument0.y);
    }
}

// do this at the end in case some inner element needs to use the escape key
kill = kill || (active && get_release_escape());

if (Controller.press_help) {
    ds_stuff_help_auto(argument0);
}

// the x button/escape key does not commit changes
if (kill) {
    script_execute(argument0.close, argument0);
}