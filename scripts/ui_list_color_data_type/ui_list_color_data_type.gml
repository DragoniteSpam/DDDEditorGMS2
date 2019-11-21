/// @param UIList
/// @param index

var list = argument0;
var index = argument1;

var type = list.entries[| index];

if (instanceof(type, DataEnum)) {
    return c_blue;
}

if (instanceof(type, DataData)) {
    return c_black;
}