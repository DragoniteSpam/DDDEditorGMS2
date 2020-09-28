/// @param UIList
/// @param x
/// @param y
function ui_render_list_data_data(argument0, argument1, argument2) {

    var list = argument0;
    var xx = argument1;
    var yy = argument2;

    var otext = list.text;

    list.text = otext + string(ds_list_size(Stuff.all_data));

    ui_render_list(list, xx, yy);

    list.text = otext;


}
