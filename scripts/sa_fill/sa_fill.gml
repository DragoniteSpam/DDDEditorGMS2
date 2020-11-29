function sa_fill() {
    if (Stuff.settings.selection.fill_type == FillTypes.ZONE) {
        safc_fill_zone();
        return;
    }
    
    sa_foreach_cell(Stuff.map.fill_types[Stuff.settings.selection.fill_type], noone);
    selection_update_autotiles();
    sa_process_selection();
}