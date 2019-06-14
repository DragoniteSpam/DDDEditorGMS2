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
                                buffer_write(missing_output, buffer_textbuffer_text, data_new.name + "." + property_new.name + " has been changed to a " + new_type + ". All instances of " + data_new.name + "." + property_new.name + " are being cast to a " + new_type + ".\r\n");
                                missing_count++;
                                for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                    var instance = data_old.instances[| k];
                                    if (property_new.type == DataTypes.INT) {
                                        instance.values[| j] = floor(instance.values[| j]);
                                    } else {
                                        instance.values[| j] = instance.values[| j];
                                    }
                                    instance.values[| j] = clamp(instance.values[| j], property_new.range_min, property_new.range_max);
                                }
                                break;
                            case DataTypes.STRING:
                                // convert if game maker won't explode
                                buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed to a " + new_type + ". All instances of " + data_new.name + "." + property_new.name + " are being cast to a " + new_type + " if possible.\r\n");
                                missing_count++;
                                for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                    var instance = data_old.instances[| k];
                                    if (validate_double(string(instance.values[| j]))) {
                                        if (property_new.type == DataTypes.INT) {
                                            instance.values[| j] = floor(real(instance.values[| j]));
                                        } else {
                                            instance.values[| j] = real(instance.values[| j]);
                                        }
                                    } else {
                                        instance.values[| j] = property_new.range_min;
                                    }
                                    instance.values[| j] = clamp(instance.values[| j], property_new.range_min, property_new.range_max);
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
                                    instance.values[| j] = property_new.range_min;
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
                                        instance.values[| j] = Stuff.tf[instance.values[| j]];
                                    } else {
                                        instance.values[| j] = string(instance.values[| j]);
                                    }
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
                                    instance.values[| j] = "";
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
                            instance.values[| j] = true;
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
                                instance.values[| j] = 0;
                            }
                        // if the properties were data types and have changed but still exist, yell
                        } else if (property_old.type_guid != property_new.type_guid) {
                            buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has been changed (" + property_old.name + " to  " +property_new.name + "). All instances of " + data_new.name + "." + property_new.name + " will be set to null.\r\n");
                            missing_count++;
                            for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                var instance = data_old.instances[| k];
                                instance.values[| j] = 0;
                            }
                        } else {
                            buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has changed to a data type or enum. All instances of " + data_new.name + "." + property_new.name + " will be set to null.\r\n");
                            missing_count++;
                            for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                                var instance = data_old.instances[| k];
                                instance.values[| j] = noone;
                            }
                        }
                        break;
                    // @todo data types
                    case DataTypes.CODE:
                        buffer_write(missing_output, buffer_text, data_new.name + "." + property_new.name + " has changed to a piece of code. All instances of " + data_new.name + "." + property_new.name + " will be set to their default code.\r\n");
                        missing_count++;
                        for (var k = 0; k < ds_list_size(data_old.instances); k++) {
                            var instance = data_old.instances[| k];
                            instance.values[| j] = property_new.default_code;
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
            for (var k = ds_list_size(instance.values); k<n_properties; k++) {
                var property = data.properties[| k];
                switch (property.type) {
                    case DataTypes.INT:
                    case DataTypes.FLOAT:
                        ds_list_add(instance.values, property.range_min);
                        break;
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                        ds_list_add(instance.values, 0);
                        break;
                    case DataTypes.STRING:
                        ds_list_add(instance.values, "");
                        break;
                    case DataTypes.BOOL:
                        ds_list_add(instance.values, false);
                        break;
                    // @todo data types
                    case DataTypes.CODE:
                        ds_list_add(instance.values, property.default_code);
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