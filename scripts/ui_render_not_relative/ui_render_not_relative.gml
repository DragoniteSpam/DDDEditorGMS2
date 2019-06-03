/// @description void ui_render_not_relative(UIThing, x, y);
/// @param UIThing
/// @param x
/// @param y
// this is mainly so that tabs don't draw their contents relative to their own position
// in the row, but you can use it for other things too

for (var i=0; i<ds_list_size(argument0.contents); i++) {
    var thing=argument0.contents[| i];
    if (thing.enabled) {
        script_execute(thing.render, thing, argument1, argument2);
    }
}
