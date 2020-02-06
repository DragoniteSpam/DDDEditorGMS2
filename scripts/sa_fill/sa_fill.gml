if (Stuff.setting_selection_fill_type == FillTypes.CAMERA_ZONE) {
    safc_fill_camera_zone();
    return 0;
}

sa_foreach_cell(Stuff.map.fill_types[Stuff.setting_selection_fill_type], noone);
selection_update_autotiles();
sa_process_selection();