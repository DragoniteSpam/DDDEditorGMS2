function dialog_create_manager_graphic_battle(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Battlers", Game.graphics.battlers,
        PREFIX_GRAPHIC_BATTLER, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    return dg;
}

function dialog_create_manager_graphic_etc(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Misc. Graphics", Game.graphics.etc,
        PREFIX_GRAPHIC_ETC, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    dg.el_frames_horizontal.interactive = false;
    dg.el_frames_vertical.interactive = false;
    dg.el_frame_speed.interactive = false;
    return dg;
}

function dialog_create_manager_graphic_overworld(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Overworld Sprites", Game.graphics.overworlds,
        PREFIX_GRAPHIC_OVERWORLD, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    return dg;
}

function dialog_create_manager_graphic_particle(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Particles", Game.graphics.particles,
        PREFIX_GRAPHIC_PARTICLE, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    return dg;
}

function dialog_create_manager_graphic_skybox(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Skyboxes", Game.graphics.skybox,
        PREFIX_GRAPHIC_SKYBOX, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    dg.el_frames_horizontal.interactive = false;
    dg.el_frames_vertical.interactive = false;
    dg.el_frame_speed.interactive = false;
    return dg;
}

function dialog_create_manager_graphic_tileset(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "Tilesets and Textures", Game.graphics.tilesets,
        PREFIX_GRAPHIC_TILESET, dmu_graphic_add_tileset, dmu_graphic_add_tileset_drag,
        dmu_graphic_delete_tileset, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    dg.el_frames_horizontal.interactive = false;
    dg.el_frames_vertical.interactive = false;
    dg.el_frame_speed.interactive = false;
    return dg;
}

function dialog_create_manager_graphic_ui(dialog) {
    var dg = dialog_create_manager_graphic(dialog, "User Interface", Game.graphics.ui,
        PREFIX_GRAPHIC_UI, dmu_graphic_add_generic, dmu_graphic_add_generic_drag,
        dmu_graphic_delete_generic, dmu_graphic_change_generic, dmu_graphic_export_generic
    );
    return dg;
}