/// @param version
function buffer_get_datatype() {

	var version = argument[0];

	return (version >= DataVersions.ID_OVERHAUL) ? buffer_datatype : buffer_datatype_old;


}
