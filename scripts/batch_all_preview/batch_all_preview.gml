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
map_container.cspreview = c_shape_create();

c_transform_identity();
c_transform_position(map.xx * TILE_WIDTH / 2, map.yy * TILE_HEIGHT / 2, 0);
c_shape_add_box(map_container.cspreview, map.xx * TILE_WIDTH / 2, map.yy * TILE_HEIGHT / 2, 0);
c_transform_identity();

for (var i = 0; i < ds_list_size(map.all_entities); i++) {
	var thing = map.all_entities[| i];
	script_execute(thing.batch, map_container.preview, map_container.wpreview, thing);
	script_execute(thing.batch_collision, map_container.cspreview, thing);
}

vertex_end(map_container.preview);
vertex_end(map_container.wpreview);
vertex_freeze(map_container.preview);
vertex_freeze(map_container.wpreview);

map_container.cpreview = c_object_create(map_container.cspreview, CollisionMasks.SURFACE, CollisionMasks.SURFACE);
c_object_set_userid(map_container.cpreview, 1337);
c_transform_identity();
c_object_apply_transform(map_container.cpreview);
c_world_add_object(map_container.cpreview);

if (!exists) {
	instance_destroy(MapContents);
}