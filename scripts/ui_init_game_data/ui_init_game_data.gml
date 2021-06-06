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
        
        el_master = create_list(this_column * cw + spacing, yy_header, "All Game Data Types: ", "<Click to define some.>", ew, eh, 32, function(list) {
            if (ds_list_empty(Stuff.all_data)) {
                momu_data_types();
            } else {
                var selection = ui_list_selection(list);
                list.root.active_type_guid = NULL;      // assume null until proven otherwise
                if (selection + 1) {
                    var listofthings = Stuff.all_data;
                    if (listofthings[| selection].GUID != list.root.active_type_guid) {
                        list.root.active_type_guid = listofthings[| selection].GUID;
                    }
                }
                ui_init_game_data_activate();
            }
        }, false, id, Stuff.all_data);
        el_master.render = function(list) {
            var otext = list.text;
            list.text = otext + string(ds_list_size(Stuff.all_data));
            ui_render_list(list, xx, yy);
            list.text = otext;
        };
        el_master.render_colors = function (list, index) {
            return (list.entries[| index].type == DataTypes.ENUM) ? c_blue : c_black;
        };
        el_master.allow_deselect = false;
        el_master.entries_are = ListEntries.INSTANCES;
        ds_list_add(contents, el_master);
        #endregion
        
        #region administrative things
        this_column = 1;
        yy = yy_header;
        
        element = create_text(this_column * cw + spacing, yy, "Data Name", ew, eh, fa_left, ew, id);
        element.render = function(text, x, y) {
            var val = guid_get(text.root.active_type_guid);
            text.text = val ? val.name : "No Data Selected";
            ui_render_text(text, x, y);
        };
        ds_list_add(contents, element);
        
        el_previous = create_button((this_column + 1) * cw + spacing, yy, "<", ew / 6, eh, fa_center, omu_data_previous, id);
        el_pages = create_text((this_column + 1) * cw + spacing, yy, "Page x/x", cw, eh, fa_center, cw, id);
        el_next = create_button((this_column + 11 / 6) * cw + spacing, yy, ">", ew / 6, eh, fa_center, omu_data_next, id);
        ds_list_add(contents, el_previous);
        ds_list_add(contents, el_pages);
        ds_list_add(contents, el_next);
        
        yy += spacing + element.height;
        
        el_instances = create_list(this_column * cw + spacing, yy, "Instances: ", "<No instances>", ew, eh, 24, ui_init_game_data_refresh, false, id, []);
        el_instances.render = ui_render_list_data_instances;
        el_instances.onmiddleclick = dialog_create_data_instance_alphabetize;
        el_instances.render_colors = function(list, index) {
            var inst = list.entries[index];
            if (string_copy(inst.name, 1, 1) == "+") return c_purple;
            if (string_copy(inst.name, 1, 3) == "---") return c_blue;
            return c_black;
        };
        el_instances.numbered = true;
        el_instances.entries_are = ListEntries.INSTANCES;
        ds_list_add(contents, el_instances);
        
        yy += spacing + ui_get_list_height(el_instances);
        
        el_inst_add = create_button(this_column * cw + spacing, yy, "Move Up", ew, eh, fa_center, function(button) {
            var data = guid_get(button.root.active_type_guid);
            var selection = ui_list_selection(button.root.el_instances);
            var instance = data.instances[selection];
            
            if (instance && (selection > 0)) {
                var t = data.instances[selection - 1];
                data.instances[selection - 1] = instance;
                data.instances[selection] = t;
                ui_list_deselect(button.root.el_instances);
                ui_list_select(button.root.el_instances, selection - 1, true);
            }
        }, id);
        ds_list_add(contents, el_inst_add);
        
        yy += spacing + element.height;
        
        el_inst_add = create_button(this_column * cw + spacing, yy, "Move Down", ew, eh, fa_center, function(button) {
            var data = guid_get(button.root.active_type_guid);
            var selection = ui_list_selection(button.root.el_instances);
            var instance = data.instances[selection];
            
            if (instance && (selection < array_length(data.instances) - 1)) {
                var t = data.instances[selection + 1];
                data.instances[selection + 1] = instance;
                data.instances[selection] = t;
                ui_list_deselect(button.root.el_instances);
                ui_list_select(button.root.el_instances, selection + 1, true);
            }
        }, id);
        ds_list_add(contents, el_inst_add);
        
        yy += spacing + element.height;
        
        el_inst_add = create_button(this_column * cw + spacing, yy, "Add Instance", ew, eh, fa_center, uimu_data_add_data, id);
        ds_list_add(contents, el_inst_add);
        
        yy += spacing + element.height;
        
        el_inst_remove = create_button(this_column * cw + spacing, yy, "Delete Instance", ew, eh, fa_center, function(button) {
            var data = guid_get(thing.root.active_type_guid);
            var selection = ui_list_selection(thing.root.el_instances);
            if (selection + 1) {
                var instance = data.instances[selection];
                ui_list_deselect(thing.root.el_instances);
                data.RemoveInstance(instance);
                instance.Destroy();
                ui_init_game_data_refresh();
            }
        }, id);
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