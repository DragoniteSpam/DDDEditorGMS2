/// @param EditorModeScribble

var mode = argument0;

// this one's not tabbed, it's just a bunch of elements floating in space
with (instance_create_depth(0, 0, 0, UIThing)) {
    var columns = 4;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_header = 64;
    var yy = 64 + eh;
    var yy_base = yy;
    
    /*
     * these are pretty important
     */
    
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    var element = create_text(xx, yy, "Text to preview:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var vx1 = 0;
    var vy1 = 0;
    var vx2 = vx1 + ew;
    var vy2 = vy1 + eh * 12;
    
    var element = create_input(xx, yy, "", ew, eh, uivc_scribble_text, mode.scribble_text, "text", validate_string, 0, 1, 10000, vx1, vy1, vx2, vy2, id);
    element.multi_line = true;
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var this_column = 1;
    var xx = this_column * cw + spacing;
    yy = yy_base;
    
    var element = create_text(xx, yy, "Scribble output:", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_render_surface(xx, yy, room_width - spacing * 2 - xx, room_height - spacing * 2 - yy, ui_render_surface_scribble_preview, null, id);
    ds_list_add(contents, element);
    
    return id;
}