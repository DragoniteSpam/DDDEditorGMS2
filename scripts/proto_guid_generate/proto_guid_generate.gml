/// @param DataContainer

var container = argument[0];

do {
    var n = string_hex(irandom(0x7fffffff));
} until (!ds_map_exists(container.proto_guids, n));

return n;