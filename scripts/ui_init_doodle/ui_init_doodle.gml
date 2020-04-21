/// @param EditorModeScribble

var mode = argument0;

// this one's not tabbed, it's just a bunch of elements floating in space
with (instance_create_depth(0, 0, 0, UIThing)) {
    var columns = 3;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_header = 64;
    var yy = 64 + eh;
    var yy_base = yy;
    
    #region scribble control
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    var xx_in = xx + ew / 3;
    var xx_out = xx + ew * 2 / 3;
    
    var element = create_text(xx, yy, "Doodle", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    #endregion
    
    #region scribble canvas
    var this_column = 1;
    var xx = this_column * cw + spacing;
    yy = yy_base;
    var xx_base = xx;
    
    var element = create_button(xx, yy, "Button", ew / 2 - spacing, eh, fa_center, null, id);
    element.tooltip = "This is here so that I don't forget to put a toolbar in its place later or something";
    ds_list_add(contents, element);
    xx = xx + ew / 2;
    
    yy += element.height + spacing;
    
    xx = xx_base;
    
    var element = create_render_surface(xx, yy, room_width - spacing * 2 - xx, room_height - spacing * 2 - yy, ui_render_surface_doodle, ui_render_surface_control_doodle, id);
    element.script_recreate = ui_render_surface_recreate_doodle;
    ds_list_add(contents, element);
    #endregion
    
    return id;
}