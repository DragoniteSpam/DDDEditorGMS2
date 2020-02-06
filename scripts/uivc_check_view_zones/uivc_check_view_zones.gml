/// @param UICheckbox

var checkbox = argument0;

Stuff.setting_view_zones = checkbox.value;
setting_set("View", "zones", Stuff.setting_view_zones);

var map = Stuff.map.active_map;
var map_contents = map.contents;

if (Stuff.setting_view_zones) {
    for (var i = 0; i < ds_list_size(map_contents.all_camera_zones); i++) {
        var zone = map_contents.all_camera_zones[| i];
        c_object_set_mask(zone.cobject, CollisionMasks.MAIN, CollisionMasks.MAIN);
    }
} else {
    for (var i = 0; i < ds_list_size(map_contents.all_camera_zones); i++) {
        var zone = map_contents.all_camera_zones[| i];
        c_object_set_mask(zone.cobject, 0, 0);
    }
}