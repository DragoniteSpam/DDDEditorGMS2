function sprite_atlas_version() {
    static dll_ref = external_define(SPRITE_ATLAS_DLL, "sprite_atlas_version", SPRITE_ATLAS_CALLTYPE, ty_string, 0);
    show_debug_message("Sprite atlasing GML version: " + SPRITE_ATLAS_VERSION);
    show_debug_message("Sprite atlasing DLL version: " + external_call(dll_ref));
}

sprite_atlas_version();