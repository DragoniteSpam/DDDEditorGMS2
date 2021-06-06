function ui_list_color_data_type(list, index) {
    return (list.entries[| index].type == DataTypes.ENUM) ? c_blue : c_black;
}