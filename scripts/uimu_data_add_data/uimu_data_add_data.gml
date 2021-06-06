function uimu_data_add_data(thing) {
    var data = guid_get(thing.root.active_type_guid);
    
    if (data) {
        var instance = new SDataInstance("");
        instance.base_guid = data.GUID;
        
        var current_index = ui_list_selection(thing.root.el_instances);
        if (current_index + 1) {
            ds_list_insert(data.instances, current_index + 1, instance);
        } else {
            ds_list_add(data.instances, instance);
        }
        
        instance.name = data.name + string(ds_list_size(data.instances));
        
        for (var i = 0; i < ds_list_size(data.properties); i++) {
            var property = data.properties[| i];
            switch (property.type) {
                case DataTypes.INT:
                case DataTypes.COLOR:
                    var plist = ds_list_create();
                    ds_list_add(plist, property.default_int);
                    ds_list_add(instance.values, plist);
                    break;
                case DataTypes.FLOAT:
                    var plist = ds_list_create();
                    ds_list_add(plist, property.default_real);
                    ds_list_add(instance.values, plist);
                    break;
                case DataTypes.ASSET_FLAG:
                    var plist = ds_list_create();
                    ds_list_add(plist, 0);
                    ds_list_add(instance.values, plist);
                    break;
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
                    var plist = ds_list_create();
                    ds_list_add(plist, 0);
                    ds_list_add(instance.values, plist);
                    break;
                case DataTypes.STRING:
                    var plist = ds_list_create();
                    ds_list_add(plist, property.default_string);
                    ds_list_add(instance.values, plist);
                    break;
                case DataTypes.BOOL:
                    var plist = ds_list_create();
                    ds_list_add(plist, clamp(property.default_int, 0, 1));
                    ds_list_add(instance.values, plist);
                    break;
                case DataTypes.CODE:
                    var plist = ds_list_create();
                    ds_list_add(plist, property.default_code);
                    ds_list_add(instance.values, plist);
                    break;
                case DataTypes.TILE:
                case DataTypes.ENTITY:
                    instance_activate_object(instance);
                    instance_destroy(instance);
                    not_yet_implemented();
                    break;
            }
        }
    }
}