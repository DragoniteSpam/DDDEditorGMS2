function omu_animation_add(thing) {
    if (ds_list_size(Stuff.all_animations) < 1000) {
        var n = string(ds_list_size(Stuff.all_animations));
        var animation = animation_create("Animation" + n, "Anim" + n);
        ui_list_deselect(thing.root.el_master);
    } else {
        emu_dialog_notice("Please don't try to create more than a million animations. Bad things will happen. In fact, they probably happened long before this. Why did you even let it get this far, anyway?");
    }
}