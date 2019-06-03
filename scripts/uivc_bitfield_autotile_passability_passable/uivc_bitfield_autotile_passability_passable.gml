/// @description uivc_bitfield_autotile_passability_passable(UIThing);
/// @param UIThing

var ts=get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]!=noone) {
    // value^1111 won't do what i want it to do
    ts.at_passage[Camera.selection_fill_autotile]=TILE_PASSABLE;
}
