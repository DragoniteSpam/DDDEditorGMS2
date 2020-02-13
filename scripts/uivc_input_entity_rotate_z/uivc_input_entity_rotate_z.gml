/// @param UIInput

var input = argument0;

var list = Stuff.map.selected_entities;

for (var i = 0; i < ds_list_size(list); i++) {
    var thing = list[| i];
    if (thing.rotateable) {
        thing.rot_zz = real(input.value);
        editor_map_mark_changed(thing);
    }
}