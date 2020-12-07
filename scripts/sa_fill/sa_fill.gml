function sa_fill() {
    if (Settings.selection.fill_type == FillTypes.ZONE) {
        safc_fill_zone();
        return;
    }
    
    sa_foreach_cell(Stuff.map.fill_types[Settings.selection.fill_type], noone);
    selection_update_autotiles();
    sa_process_selection();
}