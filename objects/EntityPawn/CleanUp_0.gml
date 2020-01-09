if (Stuff.is_quitting) exit;

entity_pawn_destroy();

Stuff.map.active_map.contents.population[ETypes.ENTITY_PAWN]--;