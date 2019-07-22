/// @param UIThing
/// @param x
/// @param y
// this is mainly so that tabs don't draw their contents relative to their own position
// in the row, but you can use it for other things too

var thing = argument0;
var xx = argument1;
var yy = argument2;

for (var i = 0; i < ds_list_size(thing.contents); i++) {
    var thing = thing.contents[| i];
    if (thing.enabled) {
        script_execute(thing.render, thing, xx, yy);
    }
}