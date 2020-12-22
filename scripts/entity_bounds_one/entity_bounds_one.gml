function entity_bounds_one(entity) {
    return new BoundingBox(entity.xx, entity.yy, entity.zz, entity.xx + 1, entity.yy + 1, entity.zz + 1);
}