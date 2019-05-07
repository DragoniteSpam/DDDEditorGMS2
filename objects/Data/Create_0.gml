name="data";
flags=0;
summary="";

deactivateable=true;
deleteable=true;

do {
    // range: [1, 2147483647] - 0 is "null"
    GUID=irandom((1<<31)-2)+1;
} until(!ds_map_exists(Stuff.all_guids, GUID));

ds_map_add(Stuff.all_guids, GUID, id);

