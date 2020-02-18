/// @param DataContainer
/// @param data
/// @param [proto]

var container = argument[0];
var data = argument[1];
var value = (argument_count > 2) ? argument[2] : proto_guid_generate(container);

container.proto_guids[? value] = data;
if (!container.first_proto_guid) {
    container.first_proto_guid = value;
}

return true;