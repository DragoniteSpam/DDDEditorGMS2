/// @param UIThing

var thing = argument0;

var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

if (data) {
    data.tags = (--data.tags + TileTerrainTags.FINAL) % TileTerrainTags.FINAL;
}
    
uivc_select_mesh_refresh(Stuff.map.selection_fill_mesh);