/// @param UIThing

var thing = argument0;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
data.tags = ++data.tags % TileTerrainTags.FINAL;;
    
uivc_select_mesh_refresh(Camera.selection_fill_mesh);