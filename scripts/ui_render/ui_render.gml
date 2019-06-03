/// @description void ui_render(UIThing, x, y);
/// @param UIThing
/// @param x
/// @param y

for (var i=0; i<ds_list_size(argument0.contents); i++) {
    var thing=argument0.contents[| i];
    if (thing.enabled) {
        script_execute(thing.render, thing, argument0.x+argument1, argument0.y+argument2);
    }
}
