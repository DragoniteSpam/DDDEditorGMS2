/// @description does NOT inherit from the normal DataEventNode, only contains the template for the node data

event_inherited();

types = ds_list_create();

enum EventNodeCustomData {
    NAME,
    TYPE,
    TYPE_GUID,                  // the ID of Item, or Skill, or Class, or whatever
    MAX,
    REQUIRED,
    DEFAULT_VALUE,              // only relevant to primitives
    ATTAINMENT,                 // script for fetching the value in the event editor; null (the script) means the default method will be used
    OUTPUT,                     // script for how to display the text of this value; null (the script) means the default method will be used
}

// other values from data types like min, max and char limit are theoretically useful
// but i really want to get this out the door so i'm not implementing them here

// for now:
// min: -1 << 31
// max:  1 << 31 - 1
// char limit (universal): 100