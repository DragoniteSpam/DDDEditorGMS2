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
     * these are pretty important
     */
    
    var this_column = 0;
    var xx = this_column * cw + spacing;
    
    /*var */el_master = create_list(xx, yy_header, "Animations: ", "<no animations>", ew, eh, 28, uivc_list_animation_editor, false, id);
    el_master.render = ui_render_list_animations;
    el_master.entries_are = ListEntries.INSTANCES;
    ds_list_add(contents, el_master);
    
    yy = yy + ui_get_list_height(el_master) + spacing;
    
    var element = create_button(xx, yy, "Add Animation", ew, eh, fa_middle, omu_animation_add, id);
    ds_list_add(contents, element);
    
    yy = yy + element.height + spacing;
    
    var element = create_button(xx, yy, "Remove Animation", ew, eh, fa_middle, omu_animation_remove, id);
    ds_list_add(contents, element);
    
    yy = yy_base;
    this_column = 1;
    xx = this_column * cw + spacing;
    
    el_name = create_input(xx, yy, "Name:", ew, eh, uivc_animation_set_name, "", "", "Instance name", validate_string, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, id);
    ds_list_add(contents, el_name);
    
    yy = yy + el_name.height + spacing;
        
    el_internal_name = create_input(xx, yy, "Internal Name:", ew, eh, uivc_animation_set_internal_name, "", "", "Internal name", validate_string_internal_name, ui_value_string, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, id);
    el_internal_name.render = ui_render_text_animation_internal_name;
    ds_list_add(contents, el_internal_name);
    
    yy = yy + el_internal_name.height + spacing;
    
    /*
     * more important stuff that needs to be done?
     */
    
    instance_deactivate_object(id);
    
    return id;
}