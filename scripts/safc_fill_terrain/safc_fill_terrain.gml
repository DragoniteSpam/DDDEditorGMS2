function safc_fill_terrain(x, y, z, params) {
    var cell = Stuff.map.active_map.Get(x, y, z);
    
    if (!cell[@ MapCellContents.MESH]) {
        var addition = instance_create_terrain();
        Stuff.map.active_map.Add(addition, x, y, z);
    }
}