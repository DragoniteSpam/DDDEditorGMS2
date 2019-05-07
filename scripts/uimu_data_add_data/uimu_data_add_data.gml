/// @description  uimu_data_add_data(UIThing);
/// @param UIThing

var data=guid_get(argument0.root.active_type_guid);

if (data!=noone){
    var instance=instance_create(0, 0, DataInstantiated);
    instance.name=data.name+"_"+string(ds_list_size(data.instances));
    instance_deactivate_object(instance);
    ds_list_add(data.instances, instance);
    
    for (var i=0; i<ds_list_size(data.properties); i++){
        var property=data.properties[| i];
        switch (property.type){
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
        }
    }
}
