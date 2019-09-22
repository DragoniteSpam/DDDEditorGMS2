/// @param DataMapContainer
/// @param version

var map = argument0;
var version = argument1;
var buffer = map.data_buffer;

map.contents = instance_create_depth(0, 0, 0, MapContents);
instance_deactivate_object(map.contents);

if (buffer_md5(buffer, 0, buffer_get_size(buffer)) != EMPTY_BUFFER_MD5) {
	buffer_seek(buffer, buffer_seek_start, 0);

	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_meta(buffer, version, map);
	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_batch(buffer, version, map);
	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_dynamic(buffer, version, map);
} // else the map has not been initialized yet and it just uses its default values