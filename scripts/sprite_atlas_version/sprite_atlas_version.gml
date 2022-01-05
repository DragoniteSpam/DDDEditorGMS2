function sprite_atlas_version() {
    show_debug_message("Sprite atlasing GML version: " + SPRITE_ATLAS_VERSION);
    show_debug_message("Sprite atlasing DLL version: " + __sprite_atlas_version());
}

sprite_atlas_version();