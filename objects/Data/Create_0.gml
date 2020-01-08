name = "data";
flags = 0;
summary = "";

file_location = DataFileLocations.NONE;
deleteable = true;

GUID = 0;
guid_set(id, guid_generate());

internal_name = "DATA_" + string_hex(GUID);

enum DataFileLocations {
    NONE, DATA, ASSET
}