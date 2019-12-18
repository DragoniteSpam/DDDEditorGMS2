/*
 * 1. check to see if there are any lists of the selected type already created; if there are, refresh them
 * 2. assign values to the property field things
 */

var data = guid_get(Stuff.data.ui.active_type_guid);
var selection = ui_list_selection(Stuff.data.ui.el_instances);

if (!data) {
    return false;
}

if (selection < 0) {
    var instance = noone;
} else {
    var instance = guid_get(data.instances[| selection].GUID);
}
/*Everything is suddenly broken, go into github to see if you can find what the latest changes to
this and ui_init_game_data_activate and ui_init_game_data were because i'm way too tired for that now*/
ui_input_set_value(Stuff.data.ui.el_inst_name, instance ? instance.name : "");
ui_input_set_value(Stuff.data.ui.el_inst_internal_name, instance ? instance.internal_name : "");

// if you got to this point, you already know data has a value
// container
var dynamic = Stuff.data.ui.el_dynamic;
var n = 0;
for (var i = 0; i < ds_list_size(dynamic.contents); i++) {
    // another container
    var column = dynamic.contents[| i];
    
    // slot 0 in column 0 is taken up by "name" which doesn't count
    var start = (i == 0) ? 2 : 0;
    
    for (var j = start; j < ds_list_size(column.contents); j++) {
        var thingy = column.contents[| j];
        
        if (thingy.is_aux) {
            continue;
        }
        
        // it'd be nice if i could just add the elements to a list and go over the
        // list without having to "physically" go down each column and row, but then
        // the list would be orphaned/memory leak unless i do some other things that
        // i don't feel like doing
        var property = data.properties[| n];
        
        // only check data, not enums
        if (property.type == DataTypes.DATA) {
            if (property.max_size == 1) {
                ui_list_deselect(thingy);
                if (property.type_guid == data.GUID) {
                    // element
                    ui_list_clear(thingy);
                    for (var k = 0; k < ds_list_size(data.instances); k++) {
                        create_list_entries(thingy, data.instances[| k]);
                    }
                }
            } // else it's a button
        } // enums can't have their members instantiated on this screen so they don't need to be refreshed
        
        if (instance) {
            if (property.max_size == 1) {
                // no need to mess with the list
                if (property.type == DataTypes.BOOL) {
                    thingy.value = ds_list_find_value(instance.values[| n], 0);
                } else {
                    ui_input_set_value(thingy, string(ds_list_find_value(instance.values[| n], 0)));
                }
                // if you re-select a data that already has one of these fields set, it should
                // be re-selected when you re-select the instance - there should be some indication
                // that the value is set
                switch (property.type) {
                    case DataTypes.DATA:
                        ui_list_deselect(thingy);
                        var datatype = guid_get(property.type_guid);
                        for (var k = 0; k < ds_list_size(datatype.instances); k++) {
                            // still no need to mess with the list
                            if (datatype.instances[| k].GUID == ds_list_find_value(instance.values[| n], 0)) {
                                ui_list_select(thingy, k, true);
                                break;
                            }
                        }
                        break;
                    case DataTypes.ENUM:
                        ui_list_deselect(thingy);
                        var datatype = guid_get(property.type_guid);
                        for (var k = 0; k < ds_list_size(datatype.properties); k++) {
                            if (datatype.properties[| k].GUID == ds_list_find_value(instance.values[| n], 0)) {
                                ui_list_select(thingy, k, true);
                                break;
                            }
                        }
                        break;
                    case DataTypes.CODE:
                        var location = get_temp_code_path(thingy);
                        if (file_exists(location)) {
                            file_delete(location);
                            thingy.editor_handle = noone;
                        }
                        break;
                    case DataTypes.ANIMATION:
                        ui_list_deselect(thingy);
                        for (var k = 0; k < ds_list_size(Stuff.all_animations); k++) {
                            // still no need to mess with the list
                            if (Stuff.all_animations[| k].GUID == ds_list_find_value(instance.values[| n], 0)) {
                                ui_list_select(thingy, k, true);
                                break;
                            }
                        }
                        break;
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
                    case DataTypes.IMG_TILESET:
                    case DataTypes.IMG_BATTLER:
                    case DataTypes.IMG_OVERWORLD:
                    case DataTypes.IMG_PARTICLE:
                    case DataTypes.IMG_UI:
                    case DataTypes.IMG_ETC:
                        ui_list_deselect(thingy);
                        // @todo gml update chained accessors, in a few places in this script
                        for (var k = 0; k < ds_list_size(thingy.entries); k++) {
                            if (thingy.entries[| k].GUID == ds_list_find_value(instance.values[| n], 0)) {
                                ui_list_select(thingy, k, true);
                                break;
                            }
                        }
                        break;
                    case DataTypes.EVENT:
                        var existing_data = guid_get(ds_list_find_value(instance.values[| n], 0));
                        thingy.text = existing_data ? existing_data.name : "<none set>";
                        thingy.event_guid = instance.values[| n];
                        thingy.instance = instance;
                        break;
                }
            } // else it's just a button
        } else {
            switch (property.type) {
                case DataTypes.INT:
                case DataTypes.FLOAT:
                case DataTypes.ENUM:
                case DataTypes.DATA:
                    ui_input_set_value(thingy,  "0");
                    break;
                case DataTypes.STRING:
                    ui_input_set_value(thingy, "");
                    break;
                case DataTypes.BOOL:
                    thingy.value = false;
                    break;
                case DataTypes.CODE:
                    thingy.value = property.default_code;
                    break;
                case DataTypes.COLOR:
                    thingy.value = c_black;
                    break;
                // all of the following are guids; you can give them defaults if you want to
                // but i'm not going to because that sounds awful
                case DataTypes.MESH:
                case DataTypes.TILE:
                case DataTypes.IMG_TILESET:
                case DataTypes.IMG_BATTLER:
                case DataTypes.IMG_OVERWORLD:
                case DataTypes.IMG_PARTICLE:
                case DataTypes.IMG_UI:
                case DataTypes.IMG_ETC:
                case DataTypes.AUTOTILE:
                case DataTypes.AUDIO_BGM:
                case DataTypes.AUDIO_SE:
                case DataTypes.ANIMATION:
                case DataTypes.MAP:
                case DataTypes.EVENT:
                    ui_list_deselect(thingy);
                    break;
                case DataTypes.ENTITY:
                    // not allowed
                    break;
            }
        }
        
        n++;
    }
}