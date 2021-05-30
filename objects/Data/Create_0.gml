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