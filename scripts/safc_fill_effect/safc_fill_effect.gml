function safc_fill_effect(x, y, z, params) {
    if (!map_get_grid_cell(x, y, z)[@ MapCellContents.EFFECT]) {
        var effect = instance_create_depth(0, 0, 0, EntityEffect);
        map_add_thing(effect, x, y, z);
        entity_effect_position_colliders(effect);
    }
}