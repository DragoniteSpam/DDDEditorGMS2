/// @param UIList
function omu_event_list_alphabetize(argument0) {

    var list = argument0;
    ui_list_deselect(list);

    ds_list_sort_name(Game.events.events);

    for (var i = 0; i < ds_list_size(Game.events.events); i++) {
        if (Game.events.events[| i] == Stuff.event.active) {
            ui_list_select(list, i, true);
            break;
        }
    }


}
