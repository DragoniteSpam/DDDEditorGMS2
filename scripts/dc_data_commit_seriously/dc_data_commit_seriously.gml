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
                    case DataTypes.FLOAT:
                        var new_type = (property_new.type == DataTypes.INT) ? "int" : "float";
                        
                        switch (property_old.type) {
                            case DataTypes.INT:
                            case DataTypes.FLOAT:
                            case DataTypes.BOOL:
                                // already numbers
                                buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a " + new_type + ". All instances of " + data_new.name + "." + property_new.name + " are being cast to a " + new_type + ".\r\n");
                                missing_count++;
                                for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                    var instance = data_old.instances[| k];
                                    if (property_new.type == DataTypes.INT) {
                                        // @todo the value list
                                        ds_list_set(instance.values[| j], 0, floor(ds_list_find_value(instance.values[| j], 0)));
                                    }
                                    // @todo the value list
                                    ds_list_set(instance.values[| j], 0, clamp(ds_list_find_value(instance.values[| j], 0), property_new.range_min, property_new.range_max));
                                }
                                break;
                            case DataTypes.STRING:
                                // convert if game maker won't explode
                                buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a " + new_type + ". All instances of " + data_new.name + "." + property_new.name + " are being cast to a " + new_type + " if possible.\r\n");
                                missing_count++;
                                for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                    var instance = data_old.instances[| k];
                                    // @todo the value list in several places
                                    if (validate_double(string(ds_list_find_value(instance.values[| j], 0)))) {
                                        if (property_new.type == DataTypes.INT) {
                                            ds_list_set(instance.values[| j], 0, floor(real(ds_list_find_value(instance.values[| j], 0))));
                                        } else {
                                            ds_list_set(instance.values[| j], 0, real(ds_list_find_value(instance.values[| j], 0)));
                                        }
                                    } else {
                                        ds_list_set(instance.values[| j], 0, property_new.range_min);
                                    }
                                    ds_list_set(instance.values[| j], 0, clamp(ds_list_find_value(instance.values[| j], 0), property_new.range_min, property_new.range_max));
                                }
                                break;
                            case DataTypes.ENUM:
                            case DataTypes.DATA:
                            case DataTypes.CODE:
                            case DataTypes.COLOR:
                            case DataTypes.MESH:
                            case DataTypes.TILE:
                            case DataTypes.TILESET:
                            case DataTypes.AUTOTILE:
                            case DataTypes.AUDIO_BGM:
                            case DataTypes.AUDIO_SE:
                                // don't convert
                                buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a " + new_type + ". All instances of " + data_new.name + "." + property_new.name + " are being set to " + string(property_new.range_min)+".\r\n");
                                missing_count++;
                                for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                    var instance = data_old.instances[| k];
                                    ds_list_set(instance.values[| j], 0, property_new.range_min);
                                }
                                break;
                        }
                        break;
                    case DataTypes.STRING:
                        switch (property_old.type) {
                            case DataTypes.INT:
                            case DataTypes.FLOAT:
                            case DataTypes.BOOL:
                                // you can just about always convert to a string
                                buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a string. All instances of " + data_new.name + "." + property_new.name + " are being cast to a string.\r\n");
                                missing_count++;
                                for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                    var instance = data_old.instances[| k];
                                    if (property_old.type == DataTypes.BOOL) {
                                        var v = Stuff.tf[ds_list_find_value(instance.values[| j], 0)];
                                    } else {
                                        var v = string(instance.values[| j]);
                                    }
                                    ds_list_set(instance.values[| j], 0, v);
                                }
                                break;
                            case DataTypes.ENUM:
                            case DataTypes.DATA:
                            case DataTypes.CODE:
                            case DataTypes.COLOR:
                            case DataTypes.MESH:
                            case DataTypes.TILE:
                            case DataTypes.TILESET:
                            case DataTypes.AUTOTILE:
                            case DataTypes.AUDIO_BGM:
                            case DataTypes.AUDIO_SE:
                                // don't convert
                                buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a string. All instances of " + data_new.name + "." + property_new.name + " are being set to an empty string.\r\n");
                                missing_count++;
                                for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                    var instance = data_old.instances[| k];
                                    ds_list_set(instance.values[| j], 0, "");
                                }
                                break;
                        }
                        break;
                    case DataTypes.BOOL:
                        // you could theoretically auto-fill based on n < 0.5 = false and n >= 0.5 = true
                        // but i highly doubt that's ever going to be useful
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a boolean. All instances of " + data_new.name + "." + property_new.name + " will be set to false.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            ds_list_set(instance.values[| j], 0, true);
                        }
                        break;
                    case DataTypes.DATA:
                    case DataTypes.ENUM:
                        // if the properties are data types, check to see if they still exist
                        if (guid_get(property_new.type_guid) == noone) {
                            if (property_old.type == DataTypes.ENUM) {
                                var typename = "enum";
                            } else {
                                var typename = "data type";
                            }
                            buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " can no longer be found (" + typename + "). All instances of " + data_new.name + "." + property_new.name + " will be set to null.\r\n");
                            missing_count++;
                            // go through all instances and zero out the property values
                            for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                var instance = data_old.instances[| k];
                                ds_list_set(instance.values[| j], 0, 0);
                            }
                        // if the properties were data types and have changed but still exist, yell
                        } else if (property_old.type_guid != property_new.type_guid) {
                            buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed (" + property_old.name + " to  " +property_new.name + "). All instances of " + data_new.name + "." + property_new.name + " will be set to null.\r\n");
                            missing_count++;
                            for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                var instance = data_old.instances[| k];
                                ds_list_set(instance.values[| j], 0, 0);
                            }
                        } else {
                            buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has changed to a data type or enum. All instances of " + data_new.name + "." + property_new.name + " will be set to null.\r\n");
                            missing_count++;
                            for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                var instance = data_old.instances[| k];
                                ds_list_set(instance.values[| j], 0, noone);
                            }
                        }
                        break;
                    // @todo data types
                    case DataTypes.CODE:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has changed to a piece of code. All instances of " + data_new.name + "." + property_new.name + " will be set to their default code.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            ds_list_set(instance.values[| j], 0, property_new.default_code);
                        }
                        break;
                    case DataTypes.COLOR:
                    case DataTypes.MESH:
                    case DataTypes.TILE:
                    case DataTypes.TILESET:
                    case DataTypes.AUTOTILE:
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
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
            if (guid_get(data[EventNodeCustomData.TYPE_GUID]) == noone) {
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
                        ds_list_add(instance.values, );
                        break;
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
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
                    // @todo data types
                    case DataTypes.CODE:
                        var plist = ds_list_create();
                        ds_list_add(plist, property.default_code);
                        ds_list_add(instance.values, plist);
                        break;
                    case DataTypes.COLOR:
                    case DataTypes.MESH:
                    case DataTypes.TILE:
                    case DataTypes.TILESET:
                    case DataTypes.AUTOTILE:
                    case DataTypes.AUDIO_BGM:
                    case DataTypes.AUDIO_SE:
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