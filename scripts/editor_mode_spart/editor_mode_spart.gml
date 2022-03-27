function editor_mode_spart() {
    Stuff.mode = Stuff.spart;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.SPART;
    }
}
