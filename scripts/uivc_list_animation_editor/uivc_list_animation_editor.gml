/// @param UIList
function uivc_list_animation_editor(argument0) {

    var list = argument0;

    if (!ds_list_empty(Game.animations)) {
        var selection = ui_list_selection(list);
        list.root.active_animation = noone;
        list.root.el_timeline.playing = false;
        list.root.el_timeline.playing_moment = 0;
    
        if (selection >= 0) {
            list.root.active_animation = Game.animations[| selection];
            ui_list_deselect(list.root.el_layers);
        }
    }


}
