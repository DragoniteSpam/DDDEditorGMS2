/// @param UIList
/// @param x
/// @param y
function ui_render_list_event_custom_outbound(argument0, argument1, argument2) {

    // this is a lot of the same code as ui_render_list which annoys me slightly,
    // except it looks directly at DataMap.all_entities in order to minimize
    // code duplication. (Lol!)
    // as such, entries, entry_colors and entries_are_instances are not used in here

    var list = argument0;
    var xx = argument1;
    var yy = argument2;

    var oentries = list.entries;
    list.entries = ds_list_create();
    ds_list_clear(list.entry_colors);

    if (oentries[0] == "") {
        ds_list_add(list.entries, "<default>");
        ds_list_add(list.entry_colors, c_blue);
    } else {
        ds_list_add(list.entries, oentries[0]);
        ds_list_add(list.entry_colors, c_black);
    }

    for (var i = 1; i < array_length(oentries); i++) {
        ds_list_add(list.entries, oentries[i]);
        ds_list_add(list.entry_colors, c_black);
    }

    ui_render_list(list, xx, yy);

    ds_list_destroy(list.entries);
    list.entries = oentries;


}
