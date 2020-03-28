/// @param UIList

var list = argument0;
ui_list_deselect(list);

ds_list_sort_name(Stuff.all_events);

for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
    if (Stuff.all_events[| i] == Stuff.event.active) {
        ui_list_select(list, i, true);
        break;
    }
}