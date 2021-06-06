function ui_list_colors_data_types(list, index) {
    return (list.entries[| index].type == DataTypes.ENUM) ? c_blue : c_black;
}