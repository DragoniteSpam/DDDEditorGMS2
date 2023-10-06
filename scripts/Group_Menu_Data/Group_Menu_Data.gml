function momu_editor_animation() {
    Stuff.animation.SetMode();
    menu_close_all();
}

function momu_data_types() {
    momu_editor_3d();
    var dialog = dialog_create_data_types();
    emu_dialog_notice("There is no Undo button. Modifying game data is a permanent action, and deleted types or properties will be lost forever!");
}

function momu_reload_images() {
    emu_dialog_notice("Not yet implemented");
}

function momu_reload_meshes() {
    for (var i = 0, n = array_length(Game.meshes); i < n; i++) {
        Game.meshes[i].Reload();
    }
    menu_close_all();
}

function momu_reload_audio() {
    emu_dialog_notice("Not yet implemented");
}

function momu_editor_3d() {
    Stuff.map.SetMode();
    menu_close_all();
}

function momu_editor_data() {
    Stuff.data.SetMode();
    menu_close_all();
}

function momu_editor_event() {
    Stuff.event.SetMode();
    menu_close_all();
}

function momu_editor_heightmap() {
    Stuff.terrain.SetMode();
    menu_close_all();
}

function momu_editor_text() {
    Stuff.text.SetMode();
    menu_close_all();
}

function momu_editor_voxelish() {
    Stuff.voxelish.SetMode();
    menu_close_all();
}

function momu_editor_spart() {
    Stuff.spart.SetMode();
    menu_close_all();
}

function momu_meshes() {
    Stuff.mesh.SetMode();
    menu_close_all();
}