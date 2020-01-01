/// @param name
/// @param compressed

var data = instance_create_depth(0, 0, 0, DataDataFile);
internal_name_set(data, argument[0]);
data.compressed = argument[1];
instance_deactivate_object(data);
return data;