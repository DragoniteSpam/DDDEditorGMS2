/// @description  ui_init_game_data();

// this one's not tabbed, it's just a bunch of elements floating in space
with (instantiate(UIThing)){
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
    
    /*
     * the list on the side is pretty important
     */
    
    var this_column = 0;
    
    /*var */el_master = create_list(this_column * cw + spacing, yy_header, "All Game Data Types: ", "<Click to define some.>", ew, eh, 32, uivc_list_data_editor, false, id);
    el_master.render = ui_render_list_data_data;
    el_master.entries_are = ListEntries.INSTANCES;
    ds_list_add(contents, el_master);
    
    /*
     * administrative things
     */
    
    var this_column = 1;
    yy = yy_header;
    
    element = create_text(this_column * cw + spacing, yy, "Data Name", ew, eh, fa_left, ew, id);
    element.render = ui_render_text_data_name;
    ds_list_add(contents, element);
    
    yy = yy + spacing + element.height;
    
    el_instances=create_list(this_column*cw+spacing, yy, "Instances: ", "<No instances>", ew, eh, 27, ui_init_game_data_refresh, false, id);
    el_instances.render=ui_render_list_data_instances;
    el_instances.numbered=true;
    el_instances.entries_are=ListEntries.INSTANCES;
    ds_list_add(contents, el_instances);
    
    yy=yy+spacing+ui_get_list_height(el_instances);
    
    el_inst_add=create_button(this_column*cw+spacing, yy, "Add Instance", ew, eh, fa_center, uimu_data_add_data, id);
    ds_list_add(contents, el_inst_add);
    
    yy=yy+spacing+element.height;
    
    el_inst_remove=create_button(this_column*cw+spacing, yy, "Remove Instance", ew, eh, fa_center, uimu_data_remove_data, id);
    ds_list_add(contents, el_inst_remove);
    
    /*
     * contents - this is actually pretty boring, it's just a container for all of the things you create on the fly
     */
    
    var this_column=2;
    yy=yy_base;
    
    el_dynamic=instance_create_depth(this_column*cw+spacing, yy, 0, UIThing);
    ds_list_add(contents, el_dynamic);
    
    /*
     * more important stuff that needs to be done?
     */
    
    active_type_guid=0;
    instance_deactivate_object(UIThing);
    
    return id;
}
