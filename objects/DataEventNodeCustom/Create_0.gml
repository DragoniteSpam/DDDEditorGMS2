/// @description  does NOT inherit from the normal DataEventNode
// it only contains the template for the node data
event_inherited();

types=ds_list_create();         // [0 name, 1 DataType, 2 DataType guid, 3 max = 1, 4 all list elements required = false]

enum EventNodeCustomData {
    NAME,
    TYPE,
    TYPE_GUID,
    MAX,
    REQUIRED
}

// other values from data types like min, max and char limit are theoretically useful
// but i really want to get this out the door so i'm not implementing them here

// for now:
// min: -1<<31
// max: 1<<31-1
// char limit (universal): 100

