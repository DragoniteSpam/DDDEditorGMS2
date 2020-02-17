/// @param DataContainer

var container = argument[0];
var n = 0;

do {
    n = irandom(0x7ffffffe) + 1;
} until (!ds_map_exists(container.proto_guids, n));

return n;