var container = Stuff.data.ui.el_dynamic;
var selection = ui_list_selection(Stuff.data.ui.el_master);

if (selection + 1) {
    Stuff.data.ui.active_type_guid = Stuff.all_data[| selection].GUID;

    var data = guid_get(Stuff.data.ui.active_type_guid);

    Stuff.data.ui.el_inst_add.interactive = false;
    Stuff.data.ui.el_inst_remove.interactive = false;

    ui_list_deselect(Stuff.data.ui.el_instances);

    // i'm really hoping UI elements are destroyed correctly now
    ds_list_clear_instances(container.contents);

    if (data) {
        // this caused some sort of null pointer exception somehow, and I haven't been able to replicate
        // it. wrapping it in this "if" should take care of it, though.
        Stuff.data.ui.el_inst_add.interactive = (data.type == DataTypes.DATA);
        Stuff.data.ui.el_inst_remove.interactive = (data.type == DataTypes.DATA);
        
        if (data.type == DataTypes.DATA) {
            var columns = 5;
            var spacing = 16;
            
            var cw =(room_width - columns * 32) / columns;
            var ew = cw - spacing * 2;
            var eh = 24;
            
            var vx1 = 0;
            var vy1 = eh * 1.5;
            var vx2 = ew;
            var vy2 = vy1 + eh;
            
            var vx1n = ew * 2 / 3;
            var vy1n = 0;
            var vx2n = ew;
            var vy2n = vy1n + eh;
            
            var b_width = 128;
            var b_height = 32;
            
            var yy = 32;
            var yy_base = yy;
            
            var col_yy = yy;
            var col_data = instance_create_depth(/*2 * cw + */spacing, 0, 0, UIThing);
            ds_list_add(container.contents, col_data);
            
            var element_header = noone;
            var element = create_input(spacing, yy, "Name:", ew, eh * 2, uivc_data_set_name, "", "Instance name", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, noone);
            element.valignment = fa_top;
            yy = yy + element.height + spacing;
            
            ds_list_add(col_data.contents, element);
            Stuff.data.ui.el_inst_name = element;
            
            var element = create_input(spacing, yy, "Internal Name:", ew, eh * 2, uivc_data_set_internal_name, "", "Internal name", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, noone);
            element.valignment = fa_top;
            element.render = ui_render_text_data_internal_name;
            yy = yy + element.height + spacing + eh / 2;
            Stuff.data.ui.el_inst_internal_name = element;
            ds_list_add(col_data.contents, element);
            
            for (var i = 0; i < ds_list_size(data.properties); i++) {
                var property = data.properties[| i];
                if (property.max_size == 1) {
                    switch (property.type) {
                        case DataTypes.INT:            // input
                            var char_limit = log10(max(1, max(abs(property.range_min), abs(property.range_max)))) + 1;
                            if (property.range_min < 0 || property.range_max < 0) {
                                char_limit++;
                            }
                            var element = create_input(spacing, yy, property.name, ew, eh, uivc_data_set_property_input, property.range_min, string(property.range_min) + " - " + string(property.range_max), validate_int,
                                property.range_min, property.range_max, char_limit, vx1n, vy1n, vx2n, vy2n, noone);
                            element.key = i;
                            var hh = element.height;
                            break;
                        case DataTypes.FLOAT:          // input
                            var element = create_input(spacing, yy, property.name, ew, eh, uivc_data_set_property_input, property.range_min, string(property.range_min) + " - " + string(property.range_max), validate_double,
                                property.range_min, property.range_max, 10 /* hard-coded, please do not touch */, vx1n, vy1n, vx2n, vy2n, noone);
                            element.key = i;
                            var hh = element.height;
                            break;
                        case DataTypes.STRING:         // input
                            var element = create_input(spacing, yy, property.name, ew, eh * 2, uivc_data_set_property_input, "", "string", validate_string,
                                0, 1, property.char_limit, vx1, vy1, vx2, vy2, noone);
                            element.valignment = fa_top;
                            element.key = i;
                            var hh = element.height + eh / 2;
                            break;
                        case DataTypes.ENUM:           // list
                        case DataTypes.DATA:           // list
                            var datadata = guid_get(property.type_guid);
                            var element = create_list(spacing, yy, property.name, "<no options: " + datadata.name + ">", ew, eh, 8, uivc_data_set_property_list, false, noone);
                            if (datadata.type == DataTypes.DATA) {
                                for (var j = 0; j < ds_list_size(datadata.instances); j++) {
                                    create_list_entries(element, datadata.instances[| j]);
                                }
                            } else {
                                for (var j = 0; j < ds_list_size(datadata.properties); j++) {
                                    create_list_entries(element, datadata.properties[| j]);
                                }
                            }
                            element.key = i;
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.BOOL:           // checkbox
                            var element = create_checkbox(spacing, yy, property.name, ew, eh, uivc_data_set_property_boolean, false, noone);
                            element.key = i;
                            var hh = element.height;
                            break;
                        case DataTypes.CODE:
                            var element_header = create_text(spacing, yy, property.name, ew, eh, fa_left, ew, noone);
                            // the vx, vy coordinates are already located below the actual element, so the actual
                            // element should be in the same for it to appear correctly (it's weird, i know)
                            var element = create_input_code(spacing, yy, "", ew, eh, 0, vy1, vx2, vy2, property.default_code, uivc_data_set_property_code, noone, i);
                            var hh = vy2;
                            break;
                        case DataTypes.COLOR:           // @todo color box
                            var element = create_button(spacing, yy, property.name, ew, eh, fa_left, not_yet_implemented, noone);
                            element.key = i;
                            var hh = element.height;
                            break;
                        case DataTypes.MESH:           // list
                            var element = create_list(spacing, yy, property.name, "<no Meshes>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.TILE:
                            not_yet_implemented();
                            break;
                        case DataTypes.IMG_TILESET:           // list
                            var element = create_list(spacing, yy, property.name, "<no Tilesets>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.IMG_BATTLER:           // list
                            var element = create_list(spacing, yy, property.name, "<no Battler sprites>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.IMG_OVERWORLD:           // list
                            var element = create_list(spacing, yy, property.name, "<no Overworld sprites>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.IMG_PARTICLE:           // list
                            var element = create_list(spacing, yy, property.name, "<no Particle sprites>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.IMG_UI:           // list
                            var element = create_list(spacing, yy, property.name, "<no UI images>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.IMG_ETC:           // list
                            var element = create_list(spacing, yy, property.name, "<no Misc images>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.AUTOTILE:           // list
                            var element = create_list(spacing, yy, property.name, "<no Autotiles>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.AUDIO_BGM:           // list
                            var element = create_list(spacing, yy, property.name, "<no BGM>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.AUDIO_SE:           // list
                            var element = create_list(spacing, yy, property.name, "<no SE>", ew, eh, 8, not_yet_implemented, false, noone);
                            element.key = i;
                            element.entries_are = ListEntries.GUIDS;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.ANIMATION:          // list
                            var element = create_list(spacing, yy, property.name, "<no Animations>", ew, eh, 8, uivc_data_set_property_list, false, noone);
                            element.key = i;
                            for (var j = 0; j < ds_list_size(Stuff.all_animations); j++) {
                                create_list_entries(element, Stuff.all_animations[| j]);
                            }
                            element.entries_are = ListEntries.INSTANCES;
                            var hh = ui_get_list_height(element);
                            break;
                        case DataTypes.ENTITY:          // list
                            var element = create_text(spacing, yy, property.name + " - invalid data type", ew, eh, fa_left, ew, noone);
                            var hh = element.height;
                            break;
                        case DataTypes.MAP:             // list
                            var element = create_text(spacing, yy, property.name + " - invalid data type", ew, eh, fa_left, ew, noone);
                            var hh = element.height;
                            break;
                    }
                } else {
                    var element = create_button(spacing, yy, property.name + " (List)", ew, eh, fa_middle, dialog_create_data_instance_property_list, noone);
                    element.key = i;
                    var hh = element.height;
                }
                
                if (yy + hh > room_height - 160) {
                    var n = ds_list_size(container.contents);
                    col_data = instance_create_depth((n /* + 2 */) * cw + spacing * 4, 0, 0, UIThing);
                    if (n > 2) {
                        col_data.enabled = false;
                    }
                    ds_list_add(container.contents, col_data);
                    
                    element.y = yy_base;
                    if (element_header) {
                        element_header.y = yy_base;
                        element.y = yy_base + element_header.height;
                    }
                    
                    yy = yy_base;
                }
                
                yy = yy + hh + spacing;
                
                if (element_header) {
                    element_header.is_aux = true;
                    ds_list_add(col_data.contents, element_header);
                    element_header = noone;
                }
                ds_list_add(col_data.contents, element);
            }
            
            var pages = ds_list_size(container.contents);
            Stuff.data.ui.el_pages.text = "Page 1 / " + string(max(1, pages - 2));
            Stuff.data.ui.el_previous.interactive = pages > 2;
            Stuff.data.ui.el_next.interactive = pages > 2;
        }
    }
}