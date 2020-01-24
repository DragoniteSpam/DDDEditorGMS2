// returns the object index; would use an enum but i like to keep things as
// simple as possible on occasion, believe it or not
// this is O(n). will not scale as well as i'd like. Use with caution.

var all_tile = true;
var all_tile_auto = true;
var all_mesh = true;
var all_mesh_autotile = true;
var all_pawn = true;
var all_effect = true;

for (var i = 0; i < ds_list_size(Stuff.map.active_map.contents.all_entities); i++) {
    var thing = Stuff.map.active_map.contents.all_entities[| i];
    if (selected(thing)) {
        if (!instanceof(thing, EntityAutoTile)) all_tile_auto = false;
        if (!instanceof(thing, EntityTile)) all_tile = false;
        if (!instanceof(thing, EntityMeshTerrain)) all_mesh_autotile = false;
        if (!instanceof(thing, EntityMesh)) all_mesh = false;
        if (!instanceof(thing, EntityPawn)) all_pawn = false;
        if (!instanceof(thing, EntityEffect)) all_effect = false;
        
        if (!(all_effect || all_pawn || all_mesh || all_mesh_autotile || all_tile || all_tile_auto)) {
            return Entity;
        }
    }
}

// check the more specific types first
if (all_tile_auto) return EntityAutoTile;
if (all_mesh_autotile) return EntityMeshTerrain;
if (all_tile) return EntityTile;
if (all_mesh) return EntityMesh;
if (all_pawn) return EntityPawn;
if (all_effect) return EntityEffect;

// this should never get to this point, but it's a failsafe
return Entity;