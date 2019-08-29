/// @param UIThing

var thing = argument0;

var data = noone;
stack_trace();
data[@ MeshArrayData.TAGS] = (--data[@ MeshArrayData.TAGS] + TileTerrainTags.FINAL) % TileTerrainTags.FINAL;
    
uivc_select_mesh_refresh(Camera.selection_fill_mesh);