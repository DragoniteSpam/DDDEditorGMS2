/// @param UIList
/// @param x
/// @param y
function ui_render_list_all_meshes(argument0, argument1, argument2) {

    var list = argument0;
    var xx = argument1;
    var yy = argument2;

    var oldentries = list.entries;
    list.entries = Stuff.all_meshes;

    var oldtext = list.text;
    list.text = list.text + string(ds_list_size(list.entries));

    ui_render_list(list, xx, yy);

    // no memory leak, although the list isn't used
    list.entries = oldentries;
    list.text = oldtext;


}
