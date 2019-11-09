/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

var ts = get_active_tileset();
ds_list_clear(list.entries);
// not my favorite way to do things but the list will never be longer
// than 32 elements long so i'll do it
for (var i = 0; i < array_length_1d(ts.autotiles); i++) {
    var data = guid_get(ts.autotiles[i]);
    ds_list_add(list.entries, data ? data.name : "<none set>");
}

ui_render_list(list, xx, yy);