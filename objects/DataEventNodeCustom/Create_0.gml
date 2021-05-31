/// @description does NOT inherit from the normal DataEventNode, only contains the template for the node data

event_inherited();

types = ds_list_create();
outbound = [NULL];

CreateJSONEventCustom = function() {
    var json = self.CreateJSONBase();
    json.types = array_create(ds_list_size(self.types));
    for (var i = 0, n = ds_list_size(self.types); i < n; i++) {
        var type = self.types[| i];
        json.types[i] = {
            name: type[0],
            type: type[1],
            guid: type[2],
            max_size: type[3],
            all_required: type[4],
        };
    }
    json.outbound = array_create(array_length(self.outbound));
    for (var i = 0, n = array_length(self.outbound); i < n; i++) {
        if (self.outbound[i]) json.outbound[i] = self.outbound[i];
    }
    return json;
};

CreateJSON = function() {
    return self.CreateJSONEventCustom();
};

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