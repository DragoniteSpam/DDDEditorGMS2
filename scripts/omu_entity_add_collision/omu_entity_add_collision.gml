/// @param UIButton
function omu_entity_add_collision(argument0) {

    var button = argument0;

    array_push(Game.vars.triggers, "Trigger " + string(array_length(Game.vars.triggers)));

    button.interactive = array_length(Game.vars.triggers) < 32;
    button.root.el_remove.interactive = array_length(Game.vars.triggers) > 4;
    button.root.el_name.interactive = array_length(Game.vars.triggers) > 0;


}
