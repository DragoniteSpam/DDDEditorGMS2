event_inherited();

save_script = serialize_save_entity_effect;
load_script = serialize_load_entity_effect;

name = "Effect";
etype = ETypes.ENTITY_EFFECT;
etype_flags = ETypeFlags.ENTITY_EFFECT;

Stuff.map.active_map.contents.population[ETypes.ENTITY_EFFECT]++;

// editor properties

slot = MapCellContents.EFFECT;
batchable = false;
render = render_effect;

// components
com_light = noone;
com_particle = noone;
com_audio = noone;