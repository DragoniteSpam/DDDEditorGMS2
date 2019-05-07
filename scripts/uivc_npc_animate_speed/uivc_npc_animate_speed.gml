/// @description  void uivc_npc_animate_speed(UIThing);
/// @param UIThing

if (script_execute(argument0.validation, argument0.value)){
    Stuff.setting_alphabetize_npc_animate_rate=clamp(script_execute(argument0.value_conversion, argument0.value),
        argument0.value_lower, argument0.value_upper);
}
