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
    
    // processes each cell in the selection, but only once
    var processed = { };
    for (var s = 0; s < ds_list_size(Stuff.map.selection); s++) {
        Stuff.map.selection[| s].foreach_cell(processed, fill_types[Settings.selection.fill_type], undefined);
    }
    
    selection_update_autotiles();
    sa_process_selection();
}