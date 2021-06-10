/// @param UIList
function omu_event_custom_list_alphabetize(argument0) {

    var list = argument0;

    var selection = Game.events.custom[| ui_list_selection(list)];
    ui_list_deselect(list);
    ds_list_sort_name(Game.events.custom);

    for (var i = 0; i < ds_list_size(Game.events.custom); i++) {
        if (Game.events.custom[| i] == selection) {
            ui_list_select(list, i, true);
            break;
        }
    }


}
