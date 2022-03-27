function editor_mode_text() {
    Stuff.mode = Stuff.text;
    
    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.TEXT;
    }
}