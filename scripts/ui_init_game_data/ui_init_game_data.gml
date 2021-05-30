function ui_init_game_data(mode) {
    // this one's not tabbed, it's just a bunch of elements floating in space
    with (instance_create_depth(0, 0, 0, UIThing)) {
        var columns = 5;
        var spacing = 16;
        
        var cw = (room_width - columns * 32) / columns;
        var ew = cw - spacing * 2;
        var eh = 24;
        
        var vx1 = cw / 2;
        var vy1 = 0;
        var vx2 = cw;
        var vy2 = eh;
        
        var b_width = 128;
        var b_height = 32;
        
        var yy_header = 64;
        var yy = 64 + eh;
        var yy_base = yy;
        var element;
        
        #region data types
        var this_column = 0;
        
        el_master = create_list(this_column * cw + spacing, yy_header, "All Game Data Types: ", "<Click to define some.>", ew, eh, 32, uivc_list_data_editor, false, id, Stuff.all_data);
        el_master.render = ui_render_list_data_data;
        el_master.render_colors = ui_list_colors_data_types;
        el_master.allow_deselect = false;
        el_master.entries_are = ListEntries.INSTANCES;
        ds_list_add(contents, el_master);
        #endregion
        
        #region administrative things
        this_column = 1;
        yy = yy_header;
        
        element = create_text(this_column * cw + spacing, yy, "Data Name", ew, eh, fa_left, ew, id);
        element.render = ui_render_text_data_name;
        ds_list_add(contents, element);
        
        el_previous = create_button((this_column + 1) * cw + spacing, yy, "<", ew / 6, eh, fa_center, omu_data_previous, id);
        el_pages = create_text((this_column + 1) * cw + spacing, yy, "Page x/x", cw, eh, fa_center, cw, id);
        el_next = create_button((this_column + 11 / 6) * cw + spacing, yy, ">", ew / 6, eh, fa_center, omu_data_next, id);
        ds_list_add(contents, el_previous);
        ds_list_add(contents, el_pages);
        ds_list_add(contents, el_next);
        
        yy += spacing + element.height;
        
        el_instances = create_list(this_column * cw + spacing, yy, "Instances: ", "<No instances>", ew, eh, 24, ui_init_game_data_refresh, false, id, noone);
        el_instances.render = ui_render_list_data_instances;
        el_instances.onmiddleclick = dialog_create_data_instance_alphabetize;
        el_instances.render_colors = ui_list_color_game_data_instances;
        el_instances.numbered = true;
        el_instances.entries_are = ListEntries.INSTANCES;
        ds_list_add(contents, el_instances);
        
        yy += spacing + ui_get_list_height(el_instances);
        
        el_inst_add = create_button(this_column * cw + spacing, yy, "Move Up", ew, eh, fa_center, uimu_data_move_up, id);
        ds_list_add(contents, el_inst_add);
        
        yy += spacing + element.height;
        
        el_inst_add = create_button(this_column * cw + spacing, yy, "Move Down", ew, eh, fa_center, uimu_data_move_down, id);
        ds_list_add(contents, el_inst_add);
        
        yy += spacing + element.height;
        
        el_inst_add = create_button(this_column * cw + spacing, yy, "Add Instance", ew, eh, fa_center, uimu_data_add_data, id);
        ds_list_add(contents, el_inst_add);
        
        yy += spacing + element.height;
        
        el_inst_remove = create_button(this_column * cw + spacing, yy, "Delete Instance", ew, eh, fa_center, uimu_data_remove_data, id);
        ds_list_add(contents, el_inst_remove);
        #endregion
        
        #region the contents list is just an empty container by default
        this_column = 2;
        yy = yy_base;
    
        el_dynamic = instance_create_depth(this_column * cw + spacing, yy, 0, UIThing);
        el_dynamic.render = ui_render_columns;
        el_dynamic.page = 0;
        ds_list_add(contents, el_dynamic);
        #endregion
        
        active_type_guid = NULL;
        instance_deactivate_object(UIThing);
        
        return id;
    }
}