function dc_autotile_selector(dialog) {
    // I really, really really don't feel like doing the commit changes thing here too
    dialog_destroy();
    // however, you do need to rebuild the autotile texture when you do this because
    // i definitely do not want to do that every time you select something new
    // later though because in the middle of the step while the 3D camera is on things
    // tend to get flipped upside-down sometimes
    Stuff.schedule_rebuild_autotile_texture = true;
}