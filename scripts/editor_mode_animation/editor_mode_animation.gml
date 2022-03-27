function editor_mode_animation() {
    Stuff.mode = Stuff.animation;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.ANIMATION;
    }
}
