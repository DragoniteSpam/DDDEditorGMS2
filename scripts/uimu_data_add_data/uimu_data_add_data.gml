function uimu_data_add_data(thing) {
    var data = guid_get(thing.root.active_type_guid);
    
    if (data) {
        var instance = new SDataInstance(data.name + string(array_length(data.instances)));
        instance.base_guid = data.GUID;
        
        var current_index = ui_list_selection(thing.root.el_instances);
        if (current_index + 1) {
            data.AddInstance(instance, current_index + 1);
        } else {
            data.AddInstance(instance, current_index);
        }
        
        for (var i = 0; i < array_length(data.properties); i++) {
            var property = data.properties[i];
            switch (property.type) {
                case DataTypes.INT:
                case DataTypes.COLOR:
                    array_push(instance.values, [property.default_int]);
                    break;
                case DataTypes.FLOAT:
                    array_push(instance.values, [property.default_real]);
                    break;
                case DataTypes.ASSET_FLAG:
                    array_push(instance.values, [0]);
                    break;
                case DataTypes.ENUM:
                case DataTypes.DATA:
                case DataTypes.MESH:
                case DataTypes.MESH_AUTOTILE:
                case DataTypes.IMG_TEXTURE:
                case DataTypes.IMG_BATTLER:
                case DataTypes.IMG_OVERWORLD:
                case DataTypes.IMG_PARTICLE:
                case DataTypes.IMG_UI:
                case DataTypes.IMG_ETC:
                case DataTypes.IMG_SKYBOX:
                case DataTypes.IMG_TILE_ANIMATION:
                case DataTypes.AUDIO_BGM:
                case DataTypes.AUDIO_SE:
                case DataTypes.ANIMATION:
                case DataTypes.MAP:
                case DataTypes.EVENT:
                    array_push(instance.values, [NULL]);
                    break;
                case DataTypes.STRING:
                    array_push(instance.values, [property.default_string]);
                    break;
                case DataTypes.BOOL:
                    array_push(instance.values, [!!property.default_int]);
                    break;
                case DataTypes.CODE:
                    array_push(instance.values, [property.default_code]);
                    break;
                case DataTypes.TILE:
                case DataTypes.ENTITY:
                    instance.Destroy();
                    not_yet_implemented();
                    break;
            }
        }
    }
}