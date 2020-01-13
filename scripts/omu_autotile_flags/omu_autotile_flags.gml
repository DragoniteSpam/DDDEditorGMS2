/// @param UIButton

var button = argument0;

var data = guid_get(get_active_tileset().autotiles[Stuff.map.selection_fill_autotile]);

if (data) {
    dialog_create_asset_flags(noone, data.name, data.flags, uivc_autotile_set_flags, data);
}