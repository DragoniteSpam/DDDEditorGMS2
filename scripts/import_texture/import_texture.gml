/// @param filename

var fn = argument[0];

var ts = tileset_create(fn);
ts.name = filename_change_ext(filename_name(fn),"");

var dialog = dialog_create_manager_tileset(noone);
ui_list_select(dialog.el_list, ds_list_size(Stuff.all_graphic_tilesets) - 1);
script_execute(dialog.el_list.onvaluechange, dialog.el_list);

return ts;