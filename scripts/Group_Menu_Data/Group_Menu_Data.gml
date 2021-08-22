function momu_editor_animation() {
    editor_mode_animation();
    menu_activate(noone);
}

function momu_data_types() {
    editor_mode_3d();
    menu_activate(noone);
    var dialog = dialog_create_data_types(noone);
    emu_dialog_notice("There is no Undo button. Modifying game data is a permanent action, and deleted types or properties will be lost forever!");
}

function momu_reload_images() {
    emu_dialog_notice("Not yet implemented");
}

function momu_reload_meshes() {
    for (var i = 0, n = array_length(Game.meshes); i < n; i++) {
        Game.meshes[i].Reload();
    }
    menu_activate(noone);
}

function momu_reload_audio() {
    emu_dialog_notice("Not yet implemented");
}

function momu_editor_3d() {
    editor_mode_3d();
    menu_activate(noone);
}

function momu_editor_data() {
    editor_mode_data();
    menu_activate(noone);
}

function momu_editor_doodle() {
    editor_mode_doodle();
    menu_activate(noone);
}

function momu_editor_event() {
    editor_mode_event();
    menu_activate(noone);
}

function momu_editor_heightmap() {
    editor_mode_heightmap();
    menu_activate(noone);
}

function momu_editor_text() {
    editor_mode_text();
    menu_activate(noone);
}

function momu_editor_particles() {
    editor_mode_particle();
    menu_activate(noone);
}

function momu_editor_scribble() {
    editor_mode_scribble();
    menu_activate(noone);
}

function momu_editor_spart() {
    editor_mode_spart();
    menu_activate(noone);
}

function momu_meshes() {
    editor_mode_meshes();
    menu_activate(noone);
}