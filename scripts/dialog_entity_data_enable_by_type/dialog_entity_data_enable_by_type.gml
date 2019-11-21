/// @param Dialog

var dialog = argument0;
var entity = dialog.entity;
var selection = ui_list_selection(dialog.el_list);
var data = entity.generic_data[| selection];

dialog.el_name.interactive = true;
ui_input_set_value(dialog.el_name, data.name);

dialog.el_data_type.interactive = true;
dialog.el_data_type.value = data.type;

dialog.el_data_ext_type.interactive = true;

switch (data.type) {
    case DataTypes.CODE:
        dialog.el_data_property_code.interactive = true;
        dialog.el_data_property_code.enabled = true;
        dialog.el_data_property_code.value = data.value_code;
        break;
    case DataTypes.STRING:
        dialog.el_data_property_string.interactive = true;
        dialog.el_data_property_string.enabled = true;
        dialog.el_data_property_string.value = data.value_string;
        break;
    case DataTypes.FLOAT:
        dialog.el_data_property_real.interactive = true;
        dialog.el_data_property_real.enabled = true;
        dialog.el_data_property_real.value = string(data.value_real);
        break;
    case DataTypes.INT:
        dialog.el_data_property_int.interactive = true;
        dialog.el_data_property_int.enabled = true;
        dialog.el_data_property_int.value = string(data.value_int);
        break;
    case DataTypes.BOOL:
        dialog.el_data_property_bool.interactive = true;
        dialog.el_data_property_bool.enabled = true;
        dialog.el_data_property_bool.value = data.value_bool;
        break;
    case DataTypes.ENUM:
    case DataTypes.DATA:
        dialog.el_data_list.enabled = true;
        dialog.el_data_type_guid.enabled = true;
        dialog.el_data_list.interactive = true;
        dialog.el_data_type_guid.interactive = true;
        break;
}