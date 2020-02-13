// this is O(n). will not scale as well as i'd like. Use with caution.

var list = ds_list_create();
var mask_mesh_auto = 1 << ETypes.ENTITY_MESH_AUTO;
var mask_tile = 1 << ETypes.ENTITY_TILE;

for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
    var thing = Stuff.map.active_map.contents.all_entities[| i];
    
    if (!instanceof(thing, EntityMeshAutotile)) {
        continue;
    }
    
    if (selected_border(thing)) {
        ds_list_add(list, thing);
    }
    // above
    if (map_get_grid_cell_mesh_autotile_data(thing.xx, thing.yy, thing.zz + 1)) {
        var neighbor = map_get_grid_cell(thing.xx, thing.yy, thing.zz + 1);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // below
    if (map_get_grid_cell_mesh_autotile_data(thing.xx, thing.yy, thing.zz - 1)) {
        var neighbor = map_get_grid_cell(thing.xx, thing.yy, thing.zz - 1);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // north
    if (map_get_grid_cell_mesh_autotile_data(thing.xx, thing.yy - 1, thing.zz)) {
        var neighbor = map_get_grid_cell(thing.xx, thing.yy - 1, thing.zz);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // south
    if (map_get_grid_cell_mesh_autotile_data(thing.xx, thing.yy + 1, thing.zz)) {
        var neighbor = map_get_grid_cell(thing.xx, thing.yy + 1, thing.zz);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // east
    if (map_get_grid_cell_mesh_autotile_data(thing.xx + 1, thing.yy, thing.zz)) {
        var neighbor = map_get_grid_cell(thing.xx + 1, thing.yy, thing.zz);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // west
    if (map_get_grid_cell_mesh_autotile_data(thing.xx - 1, thing.yy, thing.zz)) {
        var neighbor = map_get_grid_cell(thing.xx - 1, thing.yy, thing.zz);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // northwest
    if (map_get_grid_cell_mesh_autotile_data(thing.xx - 1, thing.yy - 1, thing.zz)) {
        var neighbor = map_get_grid_cell(thing.xx - 1, thing.yy - 1, thing.zz);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // northeast
    if (map_get_grid_cell_mesh_autotile_data(thing.xx + 1, thing.yy - 1, thing.zz)) {
        var neighbor = map_get_grid_cell(thing.xx + 1, thing.yy - 1, thing.zz);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // southwest
    if (map_get_grid_cell_mesh_autotile_data(thing.xx - 1, thing.yy + 1, thing.zz)) {
        var neighbor = map_get_grid_cell(thing.xx - 1, thing.yy + 1, thing.zz);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
    // southeast
    if (map_get_grid_cell_mesh_autotile_data(thing.xx + 1, thing.yy + 1, thing.zz)) {
        var neighbor = map_get_grid_cell(thing.xx + 1, thing.yy + 1, thing.zz);
        var neighbor_mesh = neighbor[@ MapCellContents.MESHPAWN];
        var neighbor_tile = neighbor[@ MapCellContents.TILE];
        if (instanceof(neighbor_mesh, EntityMeshAutotile) && selected_border(neighbor_mesh, mask_mesh_auto) ||
                instanceof(neighbor_tile, EntityTile) && selected_border(neighbor_tile, mask_tile)
            ) {
            ds_list_add(list, thing);
        }
    }
}

return list;