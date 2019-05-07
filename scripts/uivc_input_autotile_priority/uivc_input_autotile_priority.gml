/// @description  uivc_input_autotile_priority(UIThing);
/// @param UIThing

var ts=get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]!=noone){
    if (script_execute(argument0.validation, argument0.value)){
        var rv=real(argument0.value);
        if (is_clamped(rv, argument0.value_lower, argument0.value_upper)){
            ts.at_priority[Camera.selection_fill_autotile]=rv;
        }
    }
}
