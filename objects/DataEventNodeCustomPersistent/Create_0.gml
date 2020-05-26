/// @description this is NOT a descendant of Data, since it needs to persist in cases where all instances of Data may be deleted

name = "data";
flags = 0;
summary = "";

GUID = NULL;
guid_set(id, guid_generate());

internal_name = "DATA_" + string(GUID);

types = ds_list_create();
outbound = ds_list_create();