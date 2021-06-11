/// @param UIList
/// @param x
/// @param y
function ui_render_list_animations(argument0, argument1, argument2) {

    var list = argument0;
    var xx = argument1;
    var yy = argument2;

    var otext = list.text;
    list.text = otext + string(array_length(Game.animations));
    list.entries = Game.animations;

    ui_render_list(list, xx, yy);

    list.text = otext;


}
