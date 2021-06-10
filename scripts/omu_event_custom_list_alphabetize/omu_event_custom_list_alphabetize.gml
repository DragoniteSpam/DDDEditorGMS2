/// @param UIList
function omu_event_custom_list_alphabetize(argument0) {

    var list = argument0;

    var selection = Stuff.Game.events.custom[| ui_list_selection(list)];
    ui_list_deselect(list);
    ds_list_sort_name(Stuff.Game.events.custom);

    for (var i = 0; i < ds_list_size(Stuff.Game.events.custom); i++) {
        if (Stuff.Game.events.custom[| i] == selection) {
            ui_list_select(list, i, true);
            break;
        }
    }


}
