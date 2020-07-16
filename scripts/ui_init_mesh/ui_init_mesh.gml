/// @param EditorModeMesh

var mode = argument0;

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
    
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    var element = create_text(xx, yy, "text", ew, eh, fa_left, ew, id);
    ds_list_add(contents, element);
    
    yy += element.height + spacing;
    
    return id;
}