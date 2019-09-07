/// @param UIThing

var thing = argument0;

var selection = ui_list_selection(Camera.ui_game_data.el_instances);
var data = guid_get(Camera.ui_game_data.active_type_guid);
var property = data.properties[| thing.key];
var instance = guid_get(data.instances[| selection].GUID);
var plist = instance.values[| thing.key];

if (ds_list_size(plist) < property.max_size) {
    switch (property.type) {
        case DataTypes.INT:
        case DataTypes.BOOL:
            ds_list_add(plist, property.default_int);
            break;
        case DataTypes.FLOAT:
            ds_list_add(plist, property.default_real);
            break;
        case DataTypes.STRING:
            ds_list_add(plist, property.default_string);
            break;
        case DataTypes.CODE:
            ds_list_add(plist, property.default_code);
            break;
        case DataTypes.ENUM:
        case DataTypes.DATA:
        case DataTypes.AUDIO_BGM:
        case DataTypes.AUDIO_SE:
        case DataTypes.AUTOTILE:
        case DataTypes.MESH:
        case DataTypes.TILESET:
        case DataTypes.ANIMATION:
            // no default - this is just a null value
            ds_list_add(plist, 0);
            break;
        case DataTypes.COLOR:
            // no default - for now
            ds_list_add(plist, c_black);
            break;
        case DataTypes.TILE:
        case DataTypes.ENTITY:
        case DataTypes.MAP:
            not_yet_implemented();
            break;
    }
    if (thing.root.el_list_main.entries_are == ListEntries.STRINGS) {
        create_list_entries(thing.root.el_list_main, string(plist[| ds_list_size(plist) - 1]));
    } else {
        // these are IDs and can't be cast to string otherwise theyll explode
        create_list_entries(thing.root.el_list_main, plist[| ds_list_size(plist) - 1]);
    }
}