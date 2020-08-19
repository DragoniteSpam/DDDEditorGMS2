/// @param UIList
function uivc_list_animation_layers_editor(argument0) {

    var list = argument0;
    list.root.active_layer = noone;

    if (list.root.active_animation) {
        var selection = ui_list_selection(list);
    
        if (selection >= 0) {
            list.root.active_layer = list.root.active_animation.layers[| selection];
        }
    }


}
