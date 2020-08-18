/// @param DataContainer
function proto_guid_generate() {

	var container = argument[0];

	do {
	    var n = Stuff.game_asset_id + ":" + string_hex(container.proto_guid_current++, 8);
	} until (!ds_map_exists(container.proto_guids, n));

	return n;


}
