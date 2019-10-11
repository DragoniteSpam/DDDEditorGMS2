/// @param DataMapContainer

var map = argument0;

var existing_contents = map.contents;
map.contents = instance_create_depth(0, 0, 0, MapContents);
var map = map.contents;
var buffer = map.data_buffer;

if (buffer_md5(buffer, 0, buffer_get_size(buffer)) != EMPTY_BUFFER_MD5) {
	buffer_seek(buffer, buffer_seek_start, 0);
	
	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_meta(buffer, map.version, map);
	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_batch(buffer, map.version, map);
	buffer_read(buffer, buffer_datatype);
	serialize_load_map_contents_dynamic(buffer, map.version, map, true);
}

c_transform_identity();
c_transform_position(map.xx * TILE_WIDTH / 2, map.yy * TILE_HEIGHT / 2, 0);
c_shape_add_box(map.cspreview, map.xx * TILE_WIDTH / 2, map.yy * TILE_HEIGHT / 2, 0);
c_transform_identity();

// @todo this will still cause issues if the map only contains things that don't
// get batched. however, fixing that is very low on the priority list.

if (ds_list_size(map.all_entities) > 0) {
	map.preview = vertex_create_buffer();
	map.wpreview = vertex_create_buffer();
	vertex_begin(map.preview, Camera.vertex_format);
	vertex_begin(map.wpreview, Camera.vertex_format);
	map.cspreview = c_shape_create();
	
	for (var i = 0; i < ds_list_size(map.all_entities); i++) {
		var thing = map.all_entities[| i];
		script_execute(thing.batch, map.preview, map.wpreview, thing);
		script_execute(thing.batch_collision, map.cspreview, thing);
	}
	
	vertex_end(map.preview);
	vertex_end(map.wpreview);
	vertex_freeze(map.preview);
	vertex_freeze(map.wpreview);
} else {
	map.preview = noone;
	map.wpreview = noone;
}

map.cpreview = c_object_create(map.cspreview, CollisionMasks.SURFACE, CollisionMasks.SURFACE);
c_transform_identity();
c_object_apply_transform(map.cpreview);
c_world_add_object(map.cpreview);

instance_destroy(map.contents);
map.contents = existing_contents;