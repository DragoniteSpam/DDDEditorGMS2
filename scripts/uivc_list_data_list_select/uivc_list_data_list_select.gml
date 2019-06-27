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
            argument0.root.el_value.value = string(plist[| pselection]);
            break;
        case DataTypes.BOOL:
            argument0.root.el_value.value = plist[| pselection];
            break;
        case DataTypes.CODE:
            break;
        case DataTypes.ENUM:
        case DataTypes.DATA:
            break;
        case DataTypes.AUDIO_BGM:
        case DataTypes.AUDIO_SE:
        case DataTypes.AUTOTILE:
        case DataTypes.COLOR:
        case DataTypes.MESH:
        case DataTypes.TILESET:
        case DataTypes.TILE:
            break;
    }
}