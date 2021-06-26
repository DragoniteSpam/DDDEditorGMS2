function safc_fill_terrain(x, y, z, params) {
    var cell = Stuff.map.active_map.Get(x, y, z);
    
    if (!cell[@ MapCellContents.MESH]) {
        Stuff.map.active_map.Add(new EntityMeshAutotile(), x, y, z);
    }
}