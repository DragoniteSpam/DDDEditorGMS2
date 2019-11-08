/// @param UITileSelector
/// @param x
/// @param y

var selector = argument0;
var xx = argument1;
var yy = argument2;

var x1 = selector.x + xx;
var y1 = selector.y + yy;
var x2 = selector.x + selector.width;
var y2 = selector.y + selector.height;

var ts = (selector.tileset + 1) ? noone: get_active_tileset();
var image = (selector.tileset + 1) ? selector.tileset : get_active_tileset().picture;

var tex_width = sprite_get_width(image);
var tex_height = sprite_get_height(image);

draw_set_color(c_white);
draw_checkerbox(selector.x, selector.y, selector.width, selector.height);

draw_sprite_part(image, 0, selector.tile_view_x, selector.tile_view_y,
    selector.width, selector.height, selector.x, selector.y);

for (var i = selector.tile_view_x; i < selector.tile_view_x + selector.width; i = (i div Stuff.tile_size) * Stuff.tile_size + Stuff.tile_size) {
    draw_line_colour(x1 + i - selector.tile_view_x, y1, x1 + i - selector.tile_view_x, y2, c_blue, c_blue);
}

for (var i = selector.tile_view_y; i < selector.tile_view_y + selector.height; i = (i div Stuff.tile_size) * Stuff.tile_size + Stuff.tile_size) {
    draw_line_colour(x1, y1 + i - selector.tile_view_y, x2, y1 + i - selector.tile_view_y, c_blue, c_blue);
}

// drawing the selection is a pain

var selx1 = x1 + Stuff.tile_size * selector.tile_x - selector.tile_view_x;
var sely1 = y1 + Stuff.tile_size * selector.tile_y - selector.tile_view_y;
var selx2 = x1 + Stuff.tile_size * (selector.tile_x + 1) - selector.tile_view_x;
var sely2 = y1 + Stuff.tile_size * (selector.tile_y + 1) - selector.tile_view_y;

var c = c_purple;

draw_rectangle_colour(clamp(selx1, x1, x2), clamp(sely1, y1, y2), clamp(selx2, x1, x2), clamp(sely2, y1, y2), c, c, c, c, true);
draw_rectangle_colour(clamp(selx1 + 1, x1, x2), clamp(sely1 + 1, y1, y2), clamp(selx2 - 1, x1, x2), clamp(sely2 - 1, y1, y2), c, c, c, c, true);
draw_rectangle_colour(clamp(selx1 - 1, x1, x2), clamp(sely1 - 1, y1, y2), clamp(selx2 + 1, x1, x2), clamp(sely2 + 1, y1, y2), c, c, c, c, true);

draw_rectangle_colour(x1, y1, x2 - 1, y2 - 1, c_black, c_black, c_black, c_black, true);

// drawing the data on the tile is also a pain, although you only need to do it if
// the selector represents a tileset and not just a single image
if (ts) {
    draw_set_font(FDefault12Bold);
    draw_set_halign(fa_center);
    // the current valign is middle already
    
    var dx1 = selector.tile_view_x div Stuff.tile_size;
    var dy1 = selector.tile_view_y div Stuff.tile_size;
    var dx2 = ((selector.tile_view_x + selector.width) div Stuff.tile_size) + 1;
    var dy2 = ((selector.tile_view_y + selector.height) div Stuff.tile_size) + 1;
    var da = 0.75;
    
    for (var i = dx1; i < dx2; i++) {
        for (var j = dy1; j < dy2; j++) {
            var textx = x1 + i * Stuff.tile_size - selector.tile_view_x + Stuff.tile_size / 2;
            var texty = y1 + j * Stuff.tile_size - selector.tile_view_y + Stuff.tile_size / 2;
            // the 8s here are magic numbers, do not touch anything or everything will explode violently
            if ((textx - 8) >= x1 && (textx + 8) <= x2 && (texty - 8) >= y1 && (texty + 8) <= y2) {
                // could make this outside of the for loop except it displays something different
                // for the passage data than the numbers, since the numbers are meaningless
                switch (Stuff.map.tile_data_view) {
                    case TileSelectorDisplayMode.PASSAGE:
                        var value = ts.passage[# i, j];
                        if (value == 0) {
                            draw_text_colour(textx, texty, string("X"), c_black, c_black, c_black, c_black, da);
                        } else if (value == TILE_PASSABLE) {
                            draw_text_colour(textx, texty, string("O"), c_black, c_black, c_black, c_black, da);
                        } else {
                            draw_text_colour(textx, texty, string("*"), c_black, c_black, c_black, c_black, da);
                        }
                        break;
                    case TileSelectorDisplayMode.PRIORITY:
                        draw_text_colour(textx, texty, string(ts.priority[# i, j]), c_black, c_black, c_black, c_black, da);
                        break;
                    case TileSelectorDisplayMode.FLAGS:
                        draw_text_colour(textx, texty, string(ts.flags[# i, j]), c_black, c_black, c_black, c_black, da);
                        break;
                    case TileSelectorDisplayMode.TAGS:
                        draw_text_colour(textx, texty, string(ts.tags[# i, j]), c_black, c_black, c_black, c_black, da);
                        break;
                }
            }
        }
    }

    draw_set_halign(fa_left);
    draw_set_font(FDefault12);
}

// theoretically you should check to see if dialog is active but please just never
// put one of these in a dialog box, that would be awful
var inbounds = mouse_within_rectangle_determine(x1, y1, x2 - 1, y2 - 1, selector.adjust_view);
if (inbounds) {
    // select a tile
    var tx = (mouse_x_view - x1 + selector.tile_view_x) div Stuff.tile_size;
    var ty = (mouse_y_view - y1 + selector.tile_view_y) div Stuff.tile_size;
    if (Controller.press_left) {
        // this is kinda dumb because realistically you're not going to be doing anything besides this with the
        // tileset picker, but for now make it look the same as the other value change code
        script_execute(selector.onvaluechange, selector, tx, ty);
    } else if (Controller.press_right) {
        script_execute(selector.onvaluechangebackwards, selector, tx, ty);
    }
}
    
var base_x1 = selector.x;
var base_y1 = selector.y;
var base_x2 = base_x1 + selector.width;
var base_y2 = base_y1 + selector.height;
var mx = clamp(mouse_x_view, base_x1, base_x2);
var my = clamp(mouse_y_view, base_y1, base_y2);

// pan around
if (CONTORL_3D_LOOK) {
    // continuous
    if (selector.offset_x >- 1) {
        selector.tile_view_x = clamp(selector.tile_view_x + selector.offset_x - mouse_x_view, 0, tex_width - selector.width);
        selector.tile_view_y = clamp(selector.tile_view_y + selector.offset_y - mouse_y_view, 0, tex_height - selector.height);
        Stuff.mouse_3d_lock = true;
    }
    // this is an "or" - don't try to squish it into the above block because it won't work
    if (selector.offset_x >- 1 || inbounds) {
        selector.offset_x = mouse_x_view;
        selector.offset_y = mouse_y_view;
        
        window_set_cursor(cr_none);
        draw_sprite(spr_scroll, 0, mx, my);
    }
} else {
    if (selector.offset_x != -1) {
        window_set_cursor(cr_default);
        Stuff.mouse_3d_lock = false;
        selector.offset_x = -1;
        selector.offset_y = -1;
        window_mouse_set(mx + view_get_xport(view_current), my + view_get_yport(view_current));
    }
}