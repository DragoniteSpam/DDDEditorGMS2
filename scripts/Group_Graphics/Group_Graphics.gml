function draw_bezier(x1, y1, x2, y2) {
    // assumes the anchor points are in the middle: (meanx, y1) and (meanx, y2)
    var p1 = new Vector2(x1, y1);
    var p2 = p1;
    
    var xa = mean(x1, x2);
    var ya = y1;
    var xb = xa;
    var yb = y2;
    
    for (var i = 0; i < Settings.config.bezier_precision; i++) {
        p1 = p2;
        p2 = bezier_point((i + 1) / Settings.config.bezier_precision, x1, y1, xa, ya, xb, yb, x2, y2);
        draw_line(p1.x, p1.y, p2.x, p2.y);
    }
}

function draw_checkerbox(xx, yy, width, height, xscale = 1, yscale = 1, color = c_white, alpha = 1) {
    var s = sprite_get_width(b_tileset_checkers);
    var xcount = width / s * xscale;
    var ycount = height / s * yscale;
    
    draw_primitive_begin_texture(pr_trianglelist, sprite_get_texture(b_tileset_checkers, 0));
    draw_vertex_texture_colour(xx, yy, 0, 0, color, alpha);
    draw_vertex_texture_colour(xx + width, yy, xcount, 0, color, alpha);
    draw_vertex_texture_colour(xx + width, yy + height, xcount, ycount, color, alpha);
    draw_vertex_texture_colour(xx + width, yy + height, xcount, ycount, color, alpha);
    draw_vertex_texture_colour(xx, yy + height, 0, ycount, color, alpha);
    draw_vertex_texture_colour(xx, yy, 0, 0, color, alpha);
    draw_primitive_end();
}

function draw_tooltip(x, y, text) {
    // Origin is at the top-center of the box
    var offset = 4;
    var x1 = x - string_width(text) / 2 - offset;
    var y1 = y - offset;
    var x2 = x + string_width(text) / 2 + offset;
    var y2 = y + string_height(text) + offset;
    
    draw_rectangle_colour(x1, y1, x2, y2, c_white, c_white, c_white, c_white, false);
    draw_rectangle_colour(x1, y1, x2, y2, c_black, c_black, c_black, c_black, true);
    
    var halign = draw_get_halign();
    var valign = draw_get_valign();
    var font = draw_get_font();
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(FDefault);
    
    draw_text_colour(x, y, text, c_black, c_black, c_black, c_black, 1);
    
    draw_set_halign(halign);
    draw_set_valign(valign);
    draw_set_font(font);
}
function surface_rebuild(original, w, h) {
    if (!surface_exists(original)) return surface_create(w, h);
    
    if (surface_get_width(original) != w || surface_get_height(original) != h) {
        surface_free(original);
        return surface_create(w, h);
    }
    
    return original;
}
