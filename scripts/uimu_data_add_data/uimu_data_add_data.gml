/// @param UIThing

var data = guid_get(argument0.root.active_type_guid);

if (data) {
    var instance = instance_create_depth(0, 0, 0, DataInstantiated);
    
    var n = ds_list_size(data.instances);
    while (internal_name_get(string_upper(data.name) + string(n))) {
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
            case DataTypes.ENUM:
            case DataTypes.DATA:
            case DataTypes.MESH:
            case DataTypes.TILESET:
            case DataTypes.AUTOTILE:
            case DataTypes.AUDIO_BGM:
            case DataTypes.AUDIO_SE:
			case DataTypes.ANIMATION:
			case DataTypes.MAP:
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
				not_yet_implemented();
				break;
        }
    }
}