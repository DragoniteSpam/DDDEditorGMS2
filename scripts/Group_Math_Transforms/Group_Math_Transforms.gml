function transform_entity_point(entity, xx, yy, zz) {
    var matrix = matrix_build(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
    matrix = matrix_multiply(matrix, matrix_build(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz));
    matrix = matrix_multiply(matrix, matrix_build(
        (entity.xx + entity.off_xx) * TILE_WIDTH,
        (entity.yy + entity.off_yy) * TILE_HEIGHT,
        (entity.zz + entity.off_zz) * TILE_DEPTH,
        0, 0, 0, 1, 1, 1
    ));
    return matrix_transform_vertex(matrix, xx, yy, zz);
}

function transform_entity_point_reflected(entity, xx, yy, zz) {
    var water = Stuff.map.active_map.water_level;
    var matrix = matrix_build(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
    matrix = matrix_multiply(matrix, matrix_build(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz));
    matrix = matrix_multiply(matrix, matrix_build(
        (entity.xx + entity.off_xx) * TILE_WIDTH,
        (entity.yy + entity.off_yy) * TILE_HEIGHT,
        (water - (entity.zz + entity.off_zz - water)) * TILE_DEPTH,
        0, 0, 0, 1, 1, 1
    ));
    return matrix_transform_vertex(matrix, xx, yy, zz);
}