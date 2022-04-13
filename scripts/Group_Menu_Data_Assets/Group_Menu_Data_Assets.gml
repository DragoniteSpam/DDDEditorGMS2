function momu_bgm() {
    menu_close_all();
    dialog_create_manager_audio_bgm(undefined);
}

function momu_graphic_mesh_autotiles() {
    menu_close_all();
    dialog_create_manager_mesh_autotile(undefined);
}

function momu_graphics_manager() {
    menu_close_all();
    dialog_create_manager_graphics();
}

function momu_se() {
    menu_close_all();
    dialog_create_manager_audio_se(undefined);
}

#region Terrain menu actions
function momu_terrain_new() {
    menu_close_all();
    dialog_create_terrain_new();
}

function momu_terrain_save() {
    menu_close_all();
    var filename = get_save_filename_terrain("terrain.dddt");
    if (filename == "") return;
    Stuff.terrain.SaveTerrainStandalone(filename);
}

function momu_terrain_load() {
    menu_close_all();
    var filename = get_open_filename_terrain();
    if (!file_exists(filename)) return;
    Stuff.terrain.LoadTerrainStandalone(filename);
}

function momu_terrain_export() {
    menu_close_all();
    dialog_terrain_export();
}

function momu_terrain_heightmap() {
    menu_close_all();
    dialog_create_export_heightmap();
}
#endregion