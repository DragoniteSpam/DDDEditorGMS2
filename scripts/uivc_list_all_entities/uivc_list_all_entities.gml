/// @param UIList

var list = argument0;
selection_clear();

var old_mask = Stuff.setting_selection_mask;
Stuff.setting_selection_mask = ETypeFlags.ENTITY_ANY;
for (var i = ds_map_find_first(list.selected_entries); i != undefined; i = ds_map_find_next(list.selected_entries, i)) {
    var thing = list.entries[| i];
    selection_add(SelectionSingle, thing.xx, thing.yy, thing.zz);
}
sa_process_selection();
Stuff.setting_selection_mask = old_mask;