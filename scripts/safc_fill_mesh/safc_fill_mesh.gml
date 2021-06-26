/// @param x
/// @param y
/// @param z
/// @param params[]
function safc_fill_mesh(argument0, argument1, argument2, argument3) {

    var xx = argument0;
    var yy = argument1;
    var zz = argument2;
    var params = argument3;

    var cell = Stuff.map.active_map.Get(xx, yy, zz);
    
    if (!cell[@ MapCellContents.MESH]) {
        var addition = new EntityMesh(Game.meshes[Stuff.map.selection_fill_mesh]);
        Stuff.map.active_map.Add(addition, xx, yy, zz);
    }


}
