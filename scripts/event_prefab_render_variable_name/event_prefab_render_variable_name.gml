/// @param EventNode
/// @param index

var event = argument0;
var index = argument1;

// @todo gml update
var custom_data = event.custom_data[| 0];
var raw = custom_data[| 0];

if (!is_clamped(raw, 0, ds_list_size(Stuff.variables))) {
    return "n/a";
}

var data = Stuff.variables[| raw];
return data[0];