/// @param UICheckbox
function uivc_check_view_zones(argument0) {

    var checkbox = argument0;

    Settings.view.zones = checkbox.value;

    var map = Stuff.map.active_map;
    var map_contents = map.contents;

    if (Settings.view.zones) {
        for (var i = 0; i < ds_list_size(map_contents.all_zones); i++) {
            var zone = map_contents.all_zones[| i];
            c_object_set_mask(zone.cobject, CollisionMasks.MAIN, CollisionMasks.MAIN);
        }
    } else {
        for (var i = 0; i < ds_list_size(map_contents.all_zones); i++) {
            var zone = map_contents.all_zones[| i];
            c_object_set_mask(zone.cobject, 0, 0);
        }
    }


}
