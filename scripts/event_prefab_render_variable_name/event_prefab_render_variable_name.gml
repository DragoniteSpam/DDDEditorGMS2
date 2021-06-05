/// @param EventNode
/// @param index
function event_prefab_render_variable_name(argument0, argument1) {

    var event = argument0;
    var index = argument1;

    var raw = event.custom_data[0][0];

    if (!is_clamped(raw, 0, array_length(Game.vars.variables))) {
        return "n/a";
    }

    return Game.vars.variables[raw].name;


}
