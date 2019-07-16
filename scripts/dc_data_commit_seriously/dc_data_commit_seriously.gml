/// @param UIButton
// apply changes to data

var missing_output = buffer_create(1000, buffer_grow, 1);
var missing_count = 0;

for (var i = 0; i < ds_list_size(Stuff.original_data); i++) {
    var data_old = Stuff.original_data[| i];
    var data_new = Stuff.all_data[| i];
    
    if (!data_old.is_enum) {
        for (var j = 0; j < ds_list_size(data_old.properties); j++) {
            var property_old = data_old.properties[| j];
            var property_new = data_new.properties[| j];
            
            if (property_old.type != property_new.type) {
                // other changes in type
                switch (property_new.type) {
                    case DataTypes.INT:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to an int. All instances will have their values set to the default.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            var plist = instance.values[| j];
                            
                            for (var l = 0; l < ds_list_size(plist); l++) {
                                plist[| l] = property_new.default_int;
                            }
                        }
                        break;
                    case DataTypes.FLOAT:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a float. All instances will have their values set to the default.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            var plist = instance.values[| j];
                            
                            for (var l = 0; l < ds_list_size(plist); l++) {
                                plist[| l] = property_new.default_real;
                            }
                        }
                        break;
                    case DataTypes.STRING:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a string. All instances will have their values set to the default.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            var plist = instance.values[| j];
                            
                            for (var l = 0; l < ds_list_size(plist); l++) {
                                plist[| l] = property_new.default_string;
                            }
                        }
                        break;
                    case DataTypes.BOOL:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a boolean. All instances will have their values set to the default.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            var plist = instance.values[| j];
                            
                            for (var l = 0; l < ds_list_size(plist); l++) {
                                plist[| l] = property_new.default_int;
                            }
                        }
                        break;
                    case DataTypes.DATA:
                    case DataTypes.ENUM:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a data type. All instances will have their values set to null.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            var plist = instance.values[| j];
                            
                            for (var l = 0; l < ds_list_size(plist); l++) {
                                plist[| l] = 0;
                            }
                        }
                        break;
                    case DataTypes.CODE:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a code bit. All instances will have their values set to the default.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            var plist = instance.values[| j];
                            
                            for (var l = 0; l < ds_list_size(plist); l++) {
                                plist[| l] = property_new.default_code;
                            }
                        }
                        break;
                    case DataTypes.COLOR:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a color. All instances will have their values set to black.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            var plist = instance.values[| j];
                            
                            for (var l = 0; l < ds_list_size(plist); l++) {
                                plist[| l] = c_black;
                            }
                        }
                        break;
                    case DataTypes.MESH:
                    case DataTypes.TILE:
                    case DataTypes.TILESET:
                    case DataTypes.AUTOTILE:
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
                    case DataTypes.ANIMATION:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a resource. All instances will have their values set to null.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            var plist = instance.values[| j];
                            
                            for (var l = 0; l < ds_list_size(plist); l++) {
                                plist[| l] = 0;
                            }
                        }
                        break;
                }
            }
        }
    }
}

for (var i = 0; i < ds_list_size(Stuff.all_event_custom); i++) {
    var cevent = Stuff.all_event_custom[| i];
    for (var j = 0; j < ds_list_size(cevent.types); j++) {
        var data = cevent.types[| j];
        if (data[EventNodeCustomData.TYPE] == DataTypes.DATA || data[EventNodeCustomData.TYPE] == DataTypes.ENUM) {
            if (!guid_get(data[EventNodeCustomData.TYPE_GUID])) {
                // todo something
            }
        }
    }
}

// when done discard the cache and reset the old data; 99% sure this is order-
// dependant and that's a bad idea BUT IT WORKS (for now) SO DON'T TOUCH.
ds_list_destroy_instances_indirect(Stuff.original_data);
Stuff.original_data = noone;
data_apply_all_guids(Stuff.all_data);

// if any properties have been *added*, append the default values
var n_data = ds_list_size(Stuff.all_data);
for (var i = 0; i < n_data; i++) {
    var data = Stuff.all_data[| i];
    
    if (!data.is_enum) {
        var n_properties = ds_list_size(data.properties);
        for (var j = 0; j < ds_list_size(data.instances); j++) {
            var instance = data.instances[| j];
            for (var k = ds_list_size(instance.values); k < n_properties; k++) {
                var property = data.properties[| k];
                switch (property.type) {
                    case DataTypes.INT:
                    case DataTypes.FLOAT:
                        var plist = ds_list_create();
                        ds_list_add(plist, property.range_min);
                        ds_list_add(instance.values, plist);
                        break;
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                    case DataTypes.COLOR:
                    case DataTypes.MESH:
                    case DataTypes.TILE:
                    case DataTypes.TILESET:
                    case DataTypes.AUTOTILE:
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
                    case DataTypes.ANIMATION:
                        var plist = ds_list_create();
                        ds_list_add(plist, 0);
                        ds_list_add(instance.values, plist);
                        break;
                    case DataTypes.STRING:
                        var plist = ds_list_create();
                        ds_list_add(plist, "");
                        ds_list_add(instance.values, plist);
                        break;
                    case DataTypes.BOOL:
                        var plist = ds_list_create();
                        ds_list_add(plist, false);
                        ds_list_add(instance.values, plist);
                        break;
                    case DataTypes.CODE:
                        var plist = ds_list_create();
                        ds_list_add(plist, property.default_code);
                        ds_list_add(instance.values, plist);
                        break;
                }
            }
        }
    }
}

if (buffer_tell(missing_output) > 0) {
    buffer_save_ext(missing_output, "missing.txt", 0, buffer_tell(missing_output));
    dialog_create_yes_or_no(argument0.root, string(missing_count) + " things were found which you probably would like to be aware of. Would you like to view a log of these issues?", dmu_dialog_view_missing, "This is optional", "Yeah", dmu_dialog_dont_view_missing);
} else {
    dialog_destroy();
    dialog_destroy();
}