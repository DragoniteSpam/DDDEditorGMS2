/// @param UIList
function omu_event_prefab_list_alphabetize(argument0) {

    var list = argument0;

    var selection = Game.events.prefabs[ui_list_selection(list)];
    ui_list_deselect(list);
    array_sort_name(Game.events.prefabs);

    for (var i = 0; i < array_length(Game.events.prefabs); i++) {
        if (Game.events.prefabs[i] == selection) {
            ui_list_select(list, i, true);
            break;
        }
    }


}
