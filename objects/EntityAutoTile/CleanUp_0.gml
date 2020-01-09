if (Stuff.is_quitting) exit;

entity_tile_destroy();

Stuff.map.active_map.contents.population[ETypes.ENTITY_TILE]--;
Stuff.map.active_map.contents.population[ETypes.ENTITY_TILE_AUTO]--;