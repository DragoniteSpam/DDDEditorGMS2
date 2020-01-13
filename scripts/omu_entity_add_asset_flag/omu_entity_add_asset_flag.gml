/// @param UIButton

var button = argument0;

ds_list_add(Stuff.all_asset_flags, "Flag " + string(ds_list_size(Stuff.all_asset_flags)));

button.interactive = ds_list_size(Stuff.all_asset_flags) < 32;
button.root.el_remove.interactive = ds_list_size(Stuff.all_asset_flags) > 1;
button.root.el_name.interactive = ds_list_size(Stuff.all_asset_flags) > 0;