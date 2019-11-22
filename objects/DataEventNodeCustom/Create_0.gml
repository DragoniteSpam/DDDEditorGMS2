/// @description does NOT inherit from the normal DataEventNode, only contains the template for the node data

event_inherited();

types = ds_list_create();
outbound = ds_list_create();
ds_list_add(outbound, "");

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
// min: -0x80000000
// max:  0x7fffffff
// char limit (universal): 100