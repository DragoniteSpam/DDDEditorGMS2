/// @param UIList
function uivc_zone_type(argument0) {

    var list = argument0;

    Stuff.settings.selection.zone_type = ui_list_selection(list);
    setting_set("Selection", "zone-type", Stuff.settings.selection.zone_type);


}
