/// @param UIThing
/// @param x
/// @param y

var thing = argument0;
var xx = argument1;
var yy = argument2;

for (var i = 0; i < ds_list_size(thing.contents); i++) {
    var what = thing.contents[| i];
    if (what.enabled) {
        script_execute(what.render, what, thing.x + xx, thing.y + yy);
    }
}