/// @param UIButton

var button = argument[0];
var datadata = button.root.selected_data;
var index = ui_list_selection(button.root.el_list_p);

if (index < ds_list_size(datadata.properties) - 1) {
    var t = datadata.properties[| index];
    datadata.properties[| index] = datadata.properties[| index + 1];
    datadata.properties[| index + 1] = t;
    
    if (datadata.type == DataTypes.DATA) {
        for (var i = 0; i < ds_list_size(datadata.instances); i++) {
            var inst = datadata.instances[| i];
            var t = inst.values[| index];
            inst.values[| index] = inst.values[| index] + 1;
            inst.values[| index + 1] = t;
        }
    }
    
    ui_list_deselect(button.root.el_list_p);
    ui_list_select(button.root.el_list_p, index + 1, true);
}