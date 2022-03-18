function editor_mode_heightmap() {
    Stuff.mode = Stuff.terrain;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.TERRAIN;
    }
}