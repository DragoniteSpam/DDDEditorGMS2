// this one's not tabbed, it's just a bunch of elements floating in space
with (instantiate(UIThing)) {
    var columns = 5;
    var spacing = 16;
    
    var cw = (room_width - columns * 32) / columns;
    var ew = cw - spacing * 2;
    var eh = 24;
    
    var vx1 = room_width / (columns * 2) - 16;
    var vy1 = 0;
    var vx2 = vx1 + room_width / (columns * 2) - 16;
    var vy2 = vy1 + eh;
    
    var b_width = 128;
    var b_height = 32;
    
    var yy_header = 64;
    var yy = 64 + eh;
    var yy_base = yy;
    var element;
    
    active_animation = noone;
    
    /*
     * the list on the side is pretty important
     */
    
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    /*var */el_master = create_list(xx, yy_header, "Animations: ", "<no animations>", ew, eh, 28, uivc_list_animation_editor, false, id);
    el_master.render = ui_render_list_animations;
    el_master.entries_are = ListEntries.INSTANCES;
    ds_list_add(contents, el_master);
    
    yy = yy + ui_get_list_height(el_master) + spacing;
    
    var element = create_button(xx, yy, "Add Animation", ew, eh, fa_middle, null, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_button(xx, yy, "Remove Animation", ew, eh, fa_middle, null, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    /*
     * administrative things
     */
    
    var this_column = 1;
    yy = yy_header;
    
    var element = create_text(this_column * cw + spacing, yy, "Data Name", ew, eh, fa_left, ew, id);
    element.render = ui_render_text_data_name;
    ds_list_add(contents, element);
    
    /*
     * more important stuff that needs to be done?
     */
    
    active_type_guid = 0;
    instance_deactivate_object(UIThing);
    
    return id;
}