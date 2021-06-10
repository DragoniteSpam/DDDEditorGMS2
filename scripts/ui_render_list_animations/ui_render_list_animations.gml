/// @param UIList
/// @param x
/// @param y
function ui_render_list_animations(argument0, argument1, argument2) {

    var list = argument0;
    var xx = argument1;
    var yy = argument2;

    var otext = list.text;
    var oentries = list.entries;

    list.text = otext + string(ds_list_size(Game.animations));
    list.entries = Game.animations;

    ui_render_list(list, xx, yy);

    list.text = otext;
    list.entries = oentries;


}
