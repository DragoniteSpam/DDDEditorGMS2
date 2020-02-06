/// @param buffer
/// @param DataCameraZone
/// @param version

var buffer = argument0;
var zone = argument1;
var version = argument2;

zone.name = buffer_read(buffer, buffer_string);
zone.x1 = buffer_read(buffer, buffer_f32);
zone.y1 = buffer_read(buffer, buffer_f32);
zone.z1 = buffer_read(buffer, buffer_f32);
zone.x2 = buffer_read(buffer, buffer_f32);
zone.y2 = buffer_read(buffer, buffer_f32);
zone.z2 = buffer_read(buffer, buffer_f32);

zone.zone_priority = buffer_read(buffer, buffer_u16);
zone.camera_distance = buffer_read(buffer, buffer_u16);
zone.camera_angle = buffer_read(buffer, buffer_f32);
zone.camera_easing_method = buffer_read(buffer, buffer_u8);
zone.camera_easing_speed = buffer_read(buffer, buffer_f32);

// set up the collision shape
var ww = zone.x2 - zone.x1;
var hh = zone.y2 - zone.y1;
var dd = zone.z2 - zone.z1;

zone.cshape = c_shape_create();
c_shape_add_box(zone.cshape, ww * TILE_WIDTH / 2, hh * TILE_HEIGHT / 2, dd * TILE_DEPTH / 2);
zone.cobject = c_object_create(zone.cshape, CollisionMasks.MAIN, CollisionMasks.MAIN);

c_transform_position((zone.x1 + ww / 2) * TILE_WIDTH, (zone.y1 + hh / 2) * TILE_HEIGHT, (zone.z1 + dd / 2) * TILE_DEPTH);
c_object_apply_transform(zone.cobject);
c_transform_identity();

c_object_set_userid(zone.cobject, zone);
c_world_add_object(zone.cobject);

if (!Stuff.setting_view_zones) {
    c_object_set_mask(zone.cobject, 0, 0);
}