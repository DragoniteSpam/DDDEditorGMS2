/// @param UIList
/// @param x
/// @param y
function ui_render_list_animation_layers(argument0, argument1, argument2) {

    var list = argument0;
    var xx = argument1;
    var yy = argument2;

    var otext = list.text;
    var oentries = list.entries;

    if (list.root.active_animation) {
        list.text = otext + string(ds_list_size(list.root.active_animation.layers));
        list.entries = list.root.active_animation.layers;

        ui_render_list(list, xx, yy);

        list.text = otext;
        list.entries = oentries;
    } else {
        ui_render_list(list, xx, yy);
    }


}
