name = "data";
flags = 0;
summary = "";

GUID = NULL;
guid_set(id, guid_generate());

internal_name = "Data" + string_lettersdigits(GUID);

CreateJSONBase = function() {
    return {
        name: name,
        internal_name: internal_name,
        flags: flags,
        summary: summary,
        guid: GUID,
    };
};

CreateJSON = function() {
    self.CreateJSONBase();
};

LoadJSONBase = function(struct) {
    self.name = struct.name;
    internal_name_set(self.id, struct.internal_name);
    self.flags = struct.flags;
    self.summary = struct.summary;
    guid_set(self.id, struct.guid);
};

LoadJSON = function(struct) {
    self.LoadJSONBase(struct);
};