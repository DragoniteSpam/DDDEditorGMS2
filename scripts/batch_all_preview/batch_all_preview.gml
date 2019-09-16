/// @param DataMapContainer

var map_container = argument0;
var buffer = map_container.data_buffer;

var exists = map_container.contents && true;
if (!map_container.contents) {
	map_container.contents = instance_create_depth(0, 0, 0, MapContents);
}

buffer_seek(buffer, buffer_seek_start, 0);

buffer_read(buffer, buffer_datatype);
serialize_load_map_contents_meta(buffer, map_container.version, map_container);
buffer_read(buffer, buffer_datatype);
serialize_load_map_contents_batch(buffer, map_container.version, map_container);
buffer_read(buffer, buffer_datatype);
serialize_load_map_contents_dynamic(buffer, map_container.version, map_container);

var map = map_container.contents;

map_container.preview = vertex_create_buffer();
map_container.wpreview = vertex_create_buffer();
vertex_begin(map_container.preview, Camera.vertex_format);
vertex_begin(map_container.wpreview, Camera.vertex_format);

for (var i = 0; i < ds_list_size(map.all_entities); i++) {
	var thing = map.all_entities[| i];
	script_execute(thing.batch, map_container.preview, map_container.wpreview, thing);
}

vertex_end(map_container.preview);
vertex_end(map_container.wpreview);
vertex_freeze(map_container.preview);
vertex_freeze(map_container.wpreview);

if (!exists) {
	instance_destroy(MapContents);
}