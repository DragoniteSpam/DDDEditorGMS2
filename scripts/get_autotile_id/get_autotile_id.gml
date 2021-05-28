function get_autotile_id(terrain) {
    var mask = 0;
    var map = Stuff.map.active_map;
    
    var nw = !!map.GetMeshAutotileData(terrain.xx - 1, terrain.yy - 1, terrain.zz);
    var nn = !!map.GetMeshAutotileData(terrain.xx + 0, terrain.yy - 1, terrain.zz);
    var ne = !!map.GetMeshAutotileData(terrain.xx + 1, terrain.yy - 1, terrain.zz);
    var ww = !!map.GetMeshAutotileData(terrain.xx - 1, terrain.yy + 0, terrain.zz);
    var ee = !!map.GetMeshAutotileData(terrain.xx + 1, terrain.yy + 0, terrain.zz);
    var sw = !!map.GetMeshAutotileData(terrain.xx - 1, terrain.yy + 1, terrain.zz);
    var ss = !!map.GetMeshAutotileData(terrain.xx + 0, terrain.yy + 1, terrain.zz);
    var se = !!map.GetMeshAutotileData(terrain.xx + 1, terrain.yy + 1, terrain.zz);
    
    mask |= ATMask.NORTHWEST * (nw && nn && ww);
    mask |= ATMask.NORTH * nn;
    mask |= ATMask.NORTHEAST * (ne && nn && ee);
    mask |= ATMask.WEST * ww;
    mask |= ATMask.EAST * ee;
    mask |= ATMask.SOUTHWEST * (sw && ss && ww);
    mask |= ATMask.SOUTH * ss;
    mask |= ATMask.SOUTHEAST * (se && ss && ee);
    
    return mask;
}