/// @param data
/// @param refid
/// @param [map]
function refid_set() {

    var data = argument[0];
    var refid = argument[1];
    var map = (argument_count > 2 && argument[2] != undefined) ? argument[2] : Stuff.map.active_map;

    map.contents.refids[? refid] = data;
    data.REFID = refid;


}
