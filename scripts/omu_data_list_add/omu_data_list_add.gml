function omu_data_list_add(thing) {
    var selection = ui_list_selection(Stuff.data.ui.el_instances);
    var data = guid_get(Stuff.data.ui.active_type_guid);
    var property = data.properties[thing.key];
    var instance = guid_get(data.instances[selection].GUID);
    var plist = instance.values[thing.key];
    
    if (array_length(plist) < property.max_size) {
        switch (property.type) {
            case DataTypes.INT:
            case DataTypes.BOOL:
                array_push(plist, property.default_int);
                break;
            case DataTypes.FLOAT:
                array_push(plist, property.default_real);
                break;
            case DataTypes.STRING:
                array_push(plist, property.default_string);
                break;
            case DataTypes.CODE:
                array_push(plist, property.default_code);
                break;
            case DataTypes.ENUM:
            case DataTypes.DATA:
            case DataTypes.AUDIO_BGM:
            case DataTypes.AUDIO_SE:
            case DataTypes.IMG_TILE_ANIMATION:
            case DataTypes.MESH:
            case DataTypes.MESH_AUTOTILE:
            case DataTypes.IMG_TEXTURE:
            case DataTypes.IMG_BATTLER:
            case DataTypes.IMG_OVERWORLD:
            case DataTypes.IMG_PARTICLE:
            case DataTypes.IMG_UI:
            case DataTypes.IMG_SKYBOX:
            case DataTypes.IMG_ETC:
            case DataTypes.ANIMATION:
            case DataTypes.EVENT:
                // no default - this is just a null value
                array_push(plist, NULL);
                break;
            case DataTypes.COLOR:
                // no default - for now
                array_push(plist, c_black);
                break;
            case DataTypes.TILE:
            case DataTypes.ENTITY:
            case DataTypes.MAP:
                not_yet_implemented();
                break;
            case DataTypes.ASSET_FLAG:
                array_push(plist, 0);
                break;
        }
    }
}