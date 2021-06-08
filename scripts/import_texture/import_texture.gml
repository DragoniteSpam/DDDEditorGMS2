function import_texture(fn) {
    // This is specifically for handling texture files dropped onto the UI
    var ts = tileset_create(fn);
    ts.name = filename_change_ext(filename_name(fn),"");
    
    var top = ds_list_top(Stuff.dialogs);
    if (!top || !(top.flags & DialogFlags.IS_GENERIC_WARNING)) {
        var top = dialog_create_manager_graphic_tileset(undefined);
        top.flags |= DialogFlags.IS_GENERIC_WARNING;
    }
    
    ui_list_deselect(top.el_list);
    ui_list_select(top.el_list, ds_list_size(Game.graphics.tilesets) - 1);
    top.el_list.onvaluechange(top.el_list);
    
    return ts;
}