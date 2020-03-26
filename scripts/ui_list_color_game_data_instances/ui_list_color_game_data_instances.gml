/// @param UIList
/// @param index

var list = argument0;
var index = argument1;

var inst = list.entries[| index];

if (string_copy(inst.name, 1, 1) == "+") {
    return c_purple;
}

if (string_copy(inst.name, 1, 3) == "---") {
    return c_blue;
}

return c_black;