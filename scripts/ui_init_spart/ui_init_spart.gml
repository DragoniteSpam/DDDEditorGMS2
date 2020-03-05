/// @param EditorModeSpart

var mode = argument0;

// this one's not tabbed, it's just a bunch of elements floating in space
with (instance_create_depth(0, 0, 0, UIMain)) {
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
    
    // it would be best if you don't ask to access these later but if you need to these are just
    // object variables so you can look them up
    t_system = create_tab("System", 0, id);
    t_emitter = create_tab("Emitters", 0, id);
    t_type = create_tab("Types", 0, id);
    
    // the game will crash if you create a tab row with zero width.
    var tr_general = ds_list_create();
    ds_list_add(tr_general, t_system, t_emitter, t_type);
    
    ds_list_add(tabs, tr_general);
    
    active_tab = t_system;
    
    return id;
}