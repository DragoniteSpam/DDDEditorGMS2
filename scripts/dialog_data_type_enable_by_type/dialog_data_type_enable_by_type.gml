/// @param Dialog

var dialog = argument0;

// turns off all of the UI elements associated with properties of data

dialog.el_data_name.interactive = true;
dialog.el_add_p.interactive = true;
dialog.el_remove_p.interactive = true;

dialog.el_property_name.interactive = true;
dialog.el_property_name.value = dialog.selected_property.name;

dialog.el_property_type.interactive = !dialog.selected_data.is_enum;

if (dialog.selected_data.is_enum) {
    // nothing special for here
} else {
    dialog.el_property_type.interactive = true;
    dialog.el_property_ext_type.interactive = true;
    dialog.el_property_size.interactive = true;
    dialog.el_property_size.value = string(dialog.selected_property.max_size);
    
    dialog.el_property_type.value = dialog.selected_property.type;
    
    switch (dialog.selected_property.type) {
        case DataTypes.INT:
        case DataTypes.FLOAT:
            dialog.el_property_min.interactive = true;
            dialog.el_property_max.interactive = true;
            dialog.el_property_scale.interactive = true;
            dialog.el_property_min.enabled = true;
            dialog.el_property_max.enabled = true;
            dialog.el_property_scale.enabled = true;
            dialog.el_property_min.value = string(dialog.selected_property.range_min);
            dialog.el_property_max.value = string(dialog.selected_property.range_max);
            dialog.el_property_scale.value = dialog.selected_property.number_scale;
            
            if (dialog.selected_property.type == DataTypes.INT) {
                dialog.el_property_default_int.enabled = true;
                dialog.el_property_default_int.value = string(dialog.selected_property.default_int);
            } else if (dialog.selected_property.type == DataTypes.FLOAT) {
                dialog.el_property_default_real.enabled = true;
                dialog.el_property_default_real.value = string(dialog.selected_property.default_real);
            }
            break;
        case DataTypes.STRING:
            dialog.el_property_char_limit.interactive = true;
            dialog.el_property_char_limit.enabled = true;
            dialog.el_property_char_limit.value = string(dialog.selected_property.char_limit);
            dialog.el_property_default_string.enabled = true;
            dialog.el_property_default_string.value = dialog.selected_property.default_string;
            break;
        case DataTypes.BOOL:
            dialog.el_property_default_bool.enabled = true;
            dialog.el_property_default_bool.value = clamp(dialog.selected_property.default_int, 0, 1);
            break;
        case DataTypes.ENUM:
        case DataTypes.DATA:
            dialog.el_property_type_guid.interactive = true;
            dialog.el_property_type_guid.enabled = true;
            var type = guid_get(dialog.selected_property.type_guid);
            
            if (type && ((type.is_enum && dialog.selected_property.type == DataTypes.DATA)||
                    (!type.is_enum && dialog.selected_property.type == DataTypes.ENUM))) {
                dialog.el_property_type_guid.color = c_red;
            } else {
                dialog.el_property_type_guid.color = c_black;
            }
            
            if (!type) {
                dialog.el_property_type_guid.text = "Select";
            } else {
                dialog.el_property_type_guid.text = type.name + " (Select)";
            }
            
            if (dialog.selected_property.type == DataTypes.ENUM) {
                dialog.el_property_type_guid.onmouseup = omu_data_enum_select;
            } else  {
                dialog.el_property_type_guid.onmouseup = omu_data_data_select;
            }
            dialog.el_property_default_na.enabled = true;
            break;
        case DataTypes.CODE:
            dialog.el_property_default_code.enabled = true;
            dialog.el_property_default_code.value = dialog.selected_property.default_code;
            break;
        default:
            // pretty sure the others don't have anything special
            break;
    }
}