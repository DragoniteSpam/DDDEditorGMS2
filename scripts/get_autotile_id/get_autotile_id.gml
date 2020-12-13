function get_autotile_id(terrain) {
    var mask = 0;
    var map = Stuff.map.active_map;
    
    // northwest
    var what = map.GetMeshAutotileData(terrain.xx - 1, terrain.yy - 1, terrain.zz);
    var north = map.GetMeshAutotileData(terrain.xx, terrain.yy - 1, terrain.zz);
    var west = map.GetMeshAutotileData(terrain.xx - 1, terrain.yy, terrain.zz);
    if (what && north && west) mask |= ATMask.NORTHWEST;
    
    // north
    var what = map.GetMeshAutotileData(terrain.xx, terrain.yy - 1, terrain.zz);
    if (what) mask |= ATMask.NORTH;
    
    // northeast
    var what = map.GetMeshAutotileData(terrain.xx + 1, terrain.yy - 1, terrain.zz);
    var north = map.GetMeshAutotileData(terrain.xx, terrain.yy - 1, terrain.zz);
    var east = map.GetMeshAutotileData(terrain.xx + 1, terrain.yy, terrain.zz);
    if (what && north && east) mask |= ATMask.NORTHEAST;
    
    // west
    var what = map.GetMeshAutotileData(terrain.xx - 1, terrain.yy, terrain.zz);
    if (what) mask |= ATMask.WEST;
    
    // east
    var what = map.GetMeshAutotileData(terrain.xx + 1, terrain.yy, terrain.zz);
    if (what) mask |= ATMask.EAST;
    
    // southwest
    var what = map.GetMeshAutotileData(terrain.xx - 1, terrain.yy + 1, terrain.zz);
    var west = map.GetMeshAutotileData(terrain.xx - 1, terrain.yy, terrain.zz);
    var south = map.GetMeshAutotileData(terrain.xx, terrain.yy + 1, terrain.zz);
    if (what && west && south) mask |= ATMask.SOUTHWEST;
    
    // south
    var what = map.GetMeshAutotileData(terrain.xx, terrain.yy + 1, terrain.zz);
    if (what) mask |= ATMask.SOUTH;
    
    // southeast
    var what = map.GetMeshAutotileData(terrain.xx + 1, terrain.yy + 1, terrain.zz);
    var south = map.GetMeshAutotileData(terrain.xx, terrain.yy + 1, terrain.zz);
    var east = map.GetMeshAutotileData(terrain.xx + 1, terrain.yy, terrain.zz);
    if (what && south && east) mask |= ATMask.SOUTHEAST;
    
    return mask;
}