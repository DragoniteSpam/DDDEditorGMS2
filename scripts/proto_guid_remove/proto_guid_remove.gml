/// @param DataContainer
/// @param guid
function proto_guid_remove(argument0, argument1) {

    var container = argument0;
    var guid = argument1;

    if (ds_map_exists(container.proto_guids, guid)) {
        ds_map_delete(container.proto_guids, guid);
        return true;
    }

    return false;


}
