/// @param UIThing

Stuff.setting_npc_animate_rate = clamp(script_execute(argument0.value_conversion, argument0.value),
    argument0.value_lower, argument0.value_upper);