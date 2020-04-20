/// @param DataContainer

var container = argument[0];

do {
    var n = string_hex(container.proto_guid_current++);
} until (!ds_map_exists(container.proto_guids, n));

return n;