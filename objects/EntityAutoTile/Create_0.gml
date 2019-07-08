event_inherited();

save_script = serialize_save_entity_autotile;
load_script = serialize_load_entity_autotile;

name = "AutoTile";
etype = ETypes.ENTITY_TILE_AUTO;

ActiveMap.population[ETypes.ENTITY_TILE]++;
ActiveMap.population[ETypes.ENTITY_TILE_AUTO]++;

autotile_id = 0;  // ActiveMap.tileset.autotiles[]
segment_id = 0;

// possibly some animation properties?

// editor properties

// this will probably be tied to Stuff.time_int but just in case there are
// situations where you want this to be separate
frame = 0;

neighbors = array_create(8);
array_clear(neighbors, noone);

batch = batch_autotile;
render = render_autotile;
selector = select_single;

on_create = create_autotile;
on_update = update_autotile;
on_select = safc_on_autotile;