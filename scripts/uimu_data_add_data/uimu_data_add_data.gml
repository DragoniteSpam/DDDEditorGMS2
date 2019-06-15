/// @param UIThing

var data = guid_get(argument0.root.active_type_guid);

if (data != noone) {
    var instance = instantiate(DataInstantiated);
    
    var n = ds_list_size(data.instances);
    while (internal_name_get(string_upper(data.name) + string(n)) != noone) {
        n++;
    }
    instance.name = data.name + string(n);
    internal_name_set(instance, string_upper(data.name) + string(n));
    
    instance_deactivate_object(instance);
    ds_list_add(data.instances, instance);
    
    for (var i = 0; i < ds_list_size(data.properties); i++) {
        var property = data.properties[| i];
        switch (property.type) {
            case DataTypes.INT:
            case DataTypes.FLOAT:
            case DataTypes.ENUM:
            case DataTypes.DATA:
                ds_list_add(instance.values, 0);
                break;
            case DataTypes.STRING:
                ds_list_add(instance.values, "");
                break;
            case DataTypes.BOOL:
                ds_list_add(instance.values, false);
                break;
            case DataTypes.CODE:
                debug(property.default_code);
                ds_list_add(instance.values, property.default_code);
                break;
            case DataTypes.COLOR:
            case DataTypes.MESH:
            case DataTypes.TILE:
            case DataTypes.TILESET:
            case DataTypes.AUTOTILE:
            case DataTypes.AUDIO_BGM:
            case DataTypes.AUDIO_SE:
                ds_list_add(instance.values, 0);
                break;
        }
    }
}
