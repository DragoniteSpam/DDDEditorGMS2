/// @param string
/// @param UIInput

var str = argument[0];
var input = argument[1];

if (!validate_int(str, input)) {
    return false;
}

var value = real(str);

return (value * Stuff.active_map.yy * Stuff.active_map.zz) <= MAP_VOLUME_LIMIT;