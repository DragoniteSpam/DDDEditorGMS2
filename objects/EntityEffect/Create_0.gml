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
on_deselect = safc_on_effect_deselect;
on_select_ui = safc_on_effect_ui;

// components
com_light = noone;
com_particle = noone;
com_audio = noone;

cobject_x_axis = instance_create_depth(0, 0, 0, ComponentAxis);
cobject_y_axis = instance_create_depth(0, 0, 0, ComponentAxis);
cobject_z_axis = instance_create_depth(0, 0, 0, ComponentAxis);
cobject_x_plane = instance_create_depth(0, 0, 0, ComponentAxis);
cobject_y_plane = instance_create_depth(0, 0, 0, ComponentAxis);
cobject_z_plane = instance_create_depth(0, 0, 0, ComponentAxis);
cobject_x_axis.object = c_object_create(Stuff.graphics.c_shape_axis_x, 0, 0);
cobject_y_axis.object = c_object_create(Stuff.graphics.c_shape_axis_y, 0, 0);
cobject_z_axis.object = c_object_create(Stuff.graphics.c_shape_axis_z, 0, 0);
cobject_x_plane.object = c_object_create(Stuff.graphics.c_shape_axis_x_plane, 0, 0);
cobject_y_plane.object = c_object_create(Stuff.graphics.c_shape_axis_y_plane, 0, 0);
cobject_z_plane.object = c_object_create(Stuff.graphics.c_shape_axis_z_plane, 0, 0);
cobject_x_axis.axis = CollisionSpecialValues.TRANSLATE_X;
cobject_y_axis.axis = CollisionSpecialValues.TRANSLATE_Y;
cobject_z_axis.axis = CollisionSpecialValues.TRANSLATE_Z;
cobject_x_plane.axis = CollisionSpecialValues.TRANSLATE_X;
cobject_y_plane.axis = CollisionSpecialValues.TRANSLATE_Y;
cobject_z_plane.axis = CollisionSpecialValues.TRANSLATE_Z;
cobject_x_axis.parent = id;
cobject_y_axis.parent = id;
cobject_z_axis.parent = id;
cobject_x_plane.parent = id;
cobject_y_plane.parent = id;
cobject_z_plane.parent = id;
c_object_set_userid(cobject_x_axis.object, cobject_x_axis);
c_object_set_userid(cobject_y_axis.object, cobject_y_axis);
c_object_set_userid(cobject_z_axis.object, cobject_z_axis);
c_object_set_userid(cobject_x_plane.object, cobject_x_plane);
c_object_set_userid(cobject_y_plane.object, cobject_y_plane);
c_object_set_userid(cobject_z_plane.object, cobject_z_plane);
c_world_add_object(cobject_x_axis.object);
c_world_add_object(cobject_y_axis.object);
c_world_add_object(cobject_z_axis.object);
c_world_add_object(cobject_x_plane.object);
c_world_add_object(cobject_y_plane.object);
c_world_add_object(cobject_z_plane.object);

axis_over = CollisionSpecialValues.NONE;