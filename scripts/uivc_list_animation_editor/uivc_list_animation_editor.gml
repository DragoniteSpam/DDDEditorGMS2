/// @param UIList

var list = argument0;

if (!ds_list_empty(Stuff.all_animations)) {
    var selection = ui_list_selection(list);
    list.root.active_animation = 0;      // assume null until proven otherwise
    
    if (selection >= 0) {
        list.root.active_animation = Stuff.all_animations[| selection];
        list.root.el_name.value = list.root.active_animation.name;
        list.root.el_internal_name.value = list.root.active_animation.internal_name;
    }
}