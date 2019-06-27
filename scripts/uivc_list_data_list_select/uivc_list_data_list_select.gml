/// @param UIList

var pselection = ui_list_selection(argument0);

if (pselection >= 0) {
    var selection = ui_list_selection(Camera.ui_game_data.el_instances);
    var data = guid_get(Camera.ui_game_data.active_type_guid);
    var property = data.properties[| argument0.key];
    var instance = guid_get(data.instances[| selection].GUID);
    var plist = instance.values[| argument0.key];
    
    switch (property.type) {
        case DataTypes.INT:
        case DataTypes.FLOAT:
        case DataTypes.STRING:
        case DataTypes.CODE:
            argument0.root.el_value.value = string(plist[| pselection]);
            break;
        case DataTypes.BOOL:
            argument0.root.el_value.value = plist[| pselection];
            break;
        case DataTypes.ENUM:
        case DataTypes.DATA:
        case DataTypes.AUDIO_BGM:
        case DataTypes.AUDIO_SE:
        case DataTypes.AUTOTILE:
        case DataTypes.MESH:
        case DataTypes.TILESET:
            var found = -1;
            var list = argument0.root.el_value;
            ui_list_deselect(list);
            for (var i = 0; i < ds_list_size(list.entries); i++) {
                if (list.entries[| i] == plist[| pselection]) {
                    ds_map_add(list.selected_entries, i, true);
                    list.index = clamp(i - floor(list.slots / 2), 0, max(0, ds_list_size(list.entries) - list.slots - 1));
                    break;
                }
            }
            break;
        case DataTypes.COLOR:
        case DataTypes.TILE:
            stack_trace();
            break;
    }
}