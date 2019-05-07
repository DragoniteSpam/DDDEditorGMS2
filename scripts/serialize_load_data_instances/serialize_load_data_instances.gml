/// @description  void serialize_load_data_instances(buffer, version);
/// @param buffer
/// @param  version

var version=argument1;

var n_datadata=ds_list_size(Stuff.all_data);

for (var i=0; i<n_datadata; i++){
    var datadata=Stuff.all_data[| i];
    
    if (!datadata.is_enum){
        var n_properties=ds_list_size(datadata.properties);
        var n_instances=buffer_read(argument0, buffer_u16);
        
        for (var j=0; j<n_instances; j++){
            var instance=instantiate(DataInstantiated);
            ds_list_add(datadata.instances, instance);
            
            serialize_load_generic(argument0, instance, version);
            
            for (var k=0; k<n_properties; k++){
                var property=datadata.properties[| k];
                switch (property.type){
                    case DataTypes.INT:
                        // constraining this to the range allowed by the property (u8, s8,
                        // s16, etc) sounds fun but probably not worth the time
                        var btype=buffer_s32;
                        break;
                    case DataTypes.ENUM:
                    case DataTypes.DATA:
                        var btype=buffer_u32;
                        break;
                    case DataTypes.FLOAT:
                        var btype=buffer_f32;
                        break;
                    case DataTypes.STRING:
                        var btype=buffer_string;
                        break;
                    case DataTypes.BOOL:
                        // could pack these but the savings are honestly just not
                        // significant enough for me to dedicate time to this if it's
                        // not as simple as just using pack/unpack
                        var btype=buffer_u8;
                        break;
                }
                ds_list_add(instance.values, buffer_read(argument0, btype));
            }
        }
    }
}

instance_deactivate_object(DataInstantiated);
