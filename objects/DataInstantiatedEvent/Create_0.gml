/// @description This is analagous to an "event page" in RPG Maker

event_inherited();

name = "instantiated event";

// conditions - these just mirror RPG Maker currently. I'm not sure if all, if any, will
// be used and will probably try to figure out how to implement Lua or something instead

enabled = true;

// the variable comparison values need to be numbers (floats), by the way.

condition_switch_global_enabled = false;
condition_switch_global = 0;                                        // switch index
condition_variable_global_enabled = false;
condition_variable_global = 0;                                      // variable index
condition_variable_global_comparison = Comparisons.EQUAL;
condition_variable_global_value = 0;                                // value to check against
condition_switch_self_enabled = false;
condition_switch_self = 0;                                          // switch index
condition_variable_self_enabled = false;
condition_variable_self = 0;                                        // variable index
condition_variable_self_comparison = Comparisons.EQUAL;
condition_variable_self_value = 0;                                  // value to check against
// no actor condition because I don't foresee those being used
condition_code_enabled = false;
condition_code = Stuff.default_lua_event_page_condition;

enum Comparisons {
    LESS,
    LESS_OR_EQUAL,
    EQUAL,
    GREATER_OR_EQUAL,
    GREATER,
    NOT_EQUAL
}

enum ConditionBasicTypes {
    VARIABLE,
    SWITCH,
    SELF_VARIABLE,
    SELF_SWITCH,
    SCRIPT
}

// trigger
trigger = EventTriggers.ActionButton;

enum EventTriggers {
    ActionButton,
    PlayerTouch,
    EventTouch,
    Autorun,
    Parallel,
}

// not used: Image (since events are attached to entities)
// not used: Priority (since priority is attached to entities)

// the important bit

event_guid = 0;
event_entrypoint = "";