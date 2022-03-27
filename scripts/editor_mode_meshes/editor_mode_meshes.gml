function editor_mode_meshes() {
    Stuff.mode = Stuff.mesh_ed;

    if (!EDITOR_FORCE_SINGLE_MODE) {
        Settings.config.mode = ModeIDs.MESH;
    }
}
