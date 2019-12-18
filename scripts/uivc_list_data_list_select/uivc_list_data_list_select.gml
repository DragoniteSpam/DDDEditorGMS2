/// @param UIList

var list = argument0;
var pselection = ui_list_selection(list);

if (pselection + 1) {
    var selection = ui_list_selection(Stuff.data.ui.el_instances);
    var data = guid_get(Stuff.data.ui.active_type_guid);
    var property = data.properties[| list.key];
    var instance = data.instances[| selection];
    var plist = instance.values[| list.key];
    
    switch (property.type) {
        case DataTypes.INT:
        case DataTypes.FLOAT:
        case DataTypes.STRING:
        case DataTypes.CODE:
            ui_input_set_value(list.root.el_value, string(plist[| pselection]));
            break;
        case DataTypes.BOOL:
            list.root.el_value.value = plist[| pselection];
            break;
        case DataTypes.ENUM:
        case DataTypes.DATA:
        case DataTypes.AUDIO_BGM:
        case DataTypes.AUDIO_SE:
        case DataTypes.AUTOTILE:
        case DataTypes.MESH:
        case DataTypes.IMG_TILESET:
        case DataTypes.IMG_BATTLER:
        case DataTypes.IMG_OVERWORLD:
        case DataTypes.IMG_PARTICLE:
        case DataTypes.IMG_UI:
        case DataTypes.IMG_ETC:
        case DataTypes.ANIMATION:
        case DataTypes.EVENT:
            var found = -1;
            var data_list = list.root.el_value;
            ui_list_deselect(data_list);
            for (var i = 0; i < ds_list_size(data_list.entries); i++) {
                if (data_list.entries[| i].GUID == plist[| pselection]) {
                    ui_list_select(data_list, i, true);
                    break;
                }
            }
            break;
        case DataTypes.COLOR:
        case DataTypes.TILE:
        case DataTypes.ENTITY:
        case DataTypes.MAP:
            not_yet_implemented_polite();
            break;
    }
}