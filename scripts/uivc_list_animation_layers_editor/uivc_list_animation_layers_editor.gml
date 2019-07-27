/// @param UIList

var list = argument0;
list.root.active_layer = noone;

if (list.root.active_animation) {
    if (!ds_list_empty(Stuff.all_animations)) {
        var selection = ui_list_selection(list);
    
        if (selection >= 0) {
            list.root.active_layer = list.root.active_animation.layers[| selection];
        }
    }
}