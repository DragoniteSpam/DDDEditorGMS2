function transform_add(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale) {
    var matrix_current = matrix_get(matrix_world);
    var matrix_addition = matrix_build(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale);
    var matrix_new = matrix_multiply(matrix_current, matrix_addition);
    matrix_set(matrix_world, matrix_new);
    return matrix_new;
}

function transform_reset() {
    matrix_set(matrix_world, matrix_build_identity());
}

function transform_set(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale) {
    var matrix = matrix_build(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale);
    matrix_set(matrix_world, matrix);
    return matrix;
}

function transform_entity_point(entity, xx, yy, zz) {
    transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
    transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
    var matrix = transform_add(
        (entity.xx + entity.off_xx) * TILE_WIDTH,
        (entity.yy + entity.off_yy) * TILE_HEIGHT,
        (entity.zz + entity.off_zz) * TILE_DEPTH,
        0, 0, 0, 1, 1, 1
    );
    
    var result = matrix_transform_vertex(matrix, xx, yy, zz);
    transform_reset();
    return result;
}

function transform_entity_point_reflected(entity, xx, yy, zz) {
    transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
    transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
    var water = Stuff.map.active_map.water_level;
    var matrix = transform_add(
        (entity.xx + entity.off_xx) * TILE_WIDTH,
        (entity.yy + entity.off_yy) * TILE_HEIGHT,
        (water - (entity.zz + entity.off_zz - water)) * TILE_DEPTH,
        0, 0, 0, 1, 1, 1
    );
    
    var result = matrix_transform_vertex(matrix, xx, yy, zz);
    transform_reset();
    return result;
}