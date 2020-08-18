/// @param DataMapZone
function map_zone_collision(argument0) {

	var zone = argument0;

	var maxx = max(zone.x1, zone.x2);
	var maxy = max(zone.y1, zone.y2);
	var maxz = max(zone.z1, zone.z2);
	var minx = min(zone.x1, zone.x2);
	var miny = min(zone.y1, zone.y2);
	var minz = min(zone.z1, zone.z2);

	zone.x1 = minx;
	zone.y1 = miny;
	zone.z1 = minz;
	zone.x2 = maxx;
	zone.y2 = maxy;
	zone.z2 = maxz;

	var ww = (zone.x2 - zone.x1 + 1);
	var hh = (zone.y2 - zone.y1 + 1);
	var dd = (zone.z2 - zone.z1 + 1);
	zone.zz = zone.z1;

	if (zone.cobject) {
	    c_world_remove_object(zone.cobject);
	    c_object_destroy(zone.cobject);
	    c_shape_destroy(zone.cshape);
	}

	zone.cshape = c_shape_create();
	c_shape_add_box(zone.cshape, ww * TILE_WIDTH / 2, hh * TILE_HEIGHT / 2, dd * TILE_DEPTH / 2);
	zone.cobject = c_object_create_cached(zone.cshape, CollisionMasks.MAIN, CollisionMasks.MAIN);

	c_transform_position((zone.x1 + ww / 2) * TILE_WIDTH, (zone.y1 + hh / 2) * TILE_HEIGHT, (zone.z1 + dd / 2) * TILE_DEPTH);
	c_object_apply_transform(zone.cobject);
	c_transform_identity();

	c_object_set_userid(zone.cobject, zone);
	c_world_add_object(zone.cobject);

	if (!Stuff.setting_view_zones) {
	    c_object_set_mask(zone.cobject, 0, 0);
	}


}
