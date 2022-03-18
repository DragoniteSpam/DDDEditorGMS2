function editor_mode_3d() {
    Stuff.mode = Stuff.map;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.MAP;
    }
}
