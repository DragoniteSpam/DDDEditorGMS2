function editor_mode_event() {
    Stuff.mode = Stuff.event;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.EVENT;
    }
}
