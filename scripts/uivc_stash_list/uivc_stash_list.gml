/// @description void uivc_stash_list(UIList);
/// @param UIList

if (ds_map_exists(argument0.root.data, argument0.key)) {
    var secondary=argument0.root.data[? argument0.key];
} else {
    var secondary=ds_map_create();
    ds_map_add(argument0.root.data, argument0.key, secondary);
}

// this clears any values already in the map, so if you deselect
// something it'll be reflected in here as well
ds_map_copy(secondary, argument0.selected_entries);
