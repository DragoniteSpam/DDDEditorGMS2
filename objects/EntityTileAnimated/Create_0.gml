event_inherited();

save_script = serialize_save_entity_tile_animated;
load_script = serialize_load_entity_tile_animated;

name = "Animated Tile";
etype = ETypes.ENTITY_TILE_ANIMATED;
etype_flags = ETypeFlags.ENTITY_TILE_ANIMATED;

Stuff.map.active_map.contents.population[ETypes.ENTITY_TILE]++;
Stuff.map.active_map.contents.population[ETypes.ENTITY_TILE_ANIMATED]++;

batch = batch_autotile;
selector = select_single;

on_create = null;
on_select_ui = safc_on_tile_animated_ui;