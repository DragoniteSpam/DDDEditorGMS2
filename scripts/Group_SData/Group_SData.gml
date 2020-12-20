function SData() constructor {
    name = "data";
    flags = 0;
    summary = "";
    GUID = NULL;
    guid_set(id, guid_generate());
    internal_name = "SData:" + string_lettersdigits(GUID);
    
    Destroy = function() {
        if (Stuff.is_quitting) exit;
        guid_remove(GUID);
        internal_name_remove(internal_name);
    };
}