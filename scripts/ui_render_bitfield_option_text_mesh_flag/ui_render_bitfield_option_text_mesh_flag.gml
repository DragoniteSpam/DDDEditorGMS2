/// @param UIBitFieldOption
/// @param x
/// @param y

var thing = argument0;
var xx = argument1;
var yy = argument2;

var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];
thing.interactive = (data && true);

if (data) {
    thing.state = data.flags & thing.value;
}

ui_render_bitfield_option_text(thing, xx, yy);