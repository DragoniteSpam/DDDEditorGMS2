function sa_fill() {
    static fill_types = [
        safc_fill_tile, safc_fill_tile_animated,
        safc_fill_mesh, safc_fill_pawn,
        safc_fill_effect, safc_fill_terrain
    ];
    
    if (Settings.selection.fill_type == FillTypes.ZONE) {
        safc_fill_zone();
        return;
    }
    
    sa_foreach_cell(fill_types[Settings.selection.fill_type], noone);
    selection_update_autotiles();
    sa_process_selection();
}