name = "data";
flags = 0;
summary = "";

file_location = DataFileLocations.NONE;

GUID = 0;
guid_set(id, guid_generate());

internal_name = "DATA_" + string(GUID);

enum DataFileLocations {
	NONE, DATA, ASSET
}