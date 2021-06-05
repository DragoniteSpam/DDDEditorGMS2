/// @param UIButton
function omu_entity_add_collision(argument0) {

    var button = argument0;

    array_push(Game.all_event_triggers, "Trigger " + string(array_length(Game.all_event_triggers)));

    button.interactive = array_length(Game.all_event_triggers) < 32;
    button.root.el_remove.interactive = array_length(Game.all_event_triggers) > 4;
    button.root.el_name.interactive = array_length(Game.all_event_triggers) > 0;


}
