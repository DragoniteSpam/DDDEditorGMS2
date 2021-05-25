function omu_animation_layer_add(thing) {
    if (thing.root.active_animation) {
        if (ds_list_size(thing.root.active_animation.layers) < 250) {
            var n = string(ds_list_size(thing.root.active_animation.layers));
            var timeline_layer = animation_layer_create(thing.root.active_animation, "Layer " + n);
            ui_list_deselect(thing.root.el_layers);
        } else {
            emu_dialog_notice("Please don't try to create more than 250 animations.");
        }
    }
}