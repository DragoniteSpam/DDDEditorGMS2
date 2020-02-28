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
on_select = safc_on_effect;

// components
com_light = noone;
com_particle = noone;
com_audio = noone;

cobject_x = c_object_create(Stuff.graphics.c_shape_axis_x, 0, 0);
cobject_y = c_object_create(Stuff.graphics.c_shape_axis_y, 0, 0);
cobject_z = c_object_create(Stuff.graphics.c_shape_axis_z, 0, 0);
c_world_add_object(cobject_x);
c_world_add_object(cobject_y);
c_world_add_object(cobject_z);