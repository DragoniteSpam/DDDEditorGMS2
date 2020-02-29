/// @param EntityEffect

var effect = argument0;

c_transform_position(
    (effect.xx + effect.off_xx + 0.5) * TILE_WIDTH,
    (effect.yy + effect.off_yy + 0.5) * TILE_HEIGHT,
    (effect.zz + effect.off_zz + 0.5) * TILE_DEPTH
);
c_object_apply_transform(effect.cobject_x_axis.object);
c_object_apply_transform(effect.cobject_y_axis.object);
c_object_apply_transform(effect.cobject_z_axis.object);
c_object_apply_transform(effect.cobject_x_plane.object);
c_object_apply_transform(effect.cobject_y_plane.object);
c_object_apply_transform(effect.cobject_z_plane.object);
c_transform_identity();