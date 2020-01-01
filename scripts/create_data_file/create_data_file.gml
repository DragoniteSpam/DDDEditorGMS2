/// @param name
/// @param extension
/// @param compressed

var data = instance_create_depth(0, 0, 0, DataDataFile);
internal_name_set(data, argument[0]);
data.extension = argument[1];
data.compressed = argument[2];
return data;