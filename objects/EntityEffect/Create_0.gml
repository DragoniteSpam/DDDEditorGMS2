event_inherited();

save_script = serialize_save_entity_effect;

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

LoadJSONEffect = function(source) {
    self.LoadJSONBase(source);
    var light = source.com.light;
    var particle = source.com.particle;
    var audio = source.com.audio;
    self.com_light = light ? (new global.light_type_constructors[light.type](self, light)) : undefined;
    self.com_particle = particle ? (new ComponentParticle(self, particle)) : undefined;
    self.com_audio = audio ? (new ComponentAudio(self, audio)) : undefined;
};

LoadJSON = function(source) {
    self.LoadJSONEffect(source);
};

CreateJSONEffect = function() {
    var json = self.CreateJSONBase();
    json.effects = {
        com: {
            light: self.com_light ? self.com_light.CreateJSON() : undefined,
            particle: self.com_particle ? self.com_particle.CreateJSON() : undefined,
            audio: self.com_audio ? self.com_audio.CreateJSON() : undefined,
        },
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONEffect();
};

// editor garbage
cobject_x_axis = new EditorComponentAxis(self.id, c_object_create_cached(Stuff.graphics.c_shape_axis_x, 0, 0), CollisionSpecialValues.TRANSLATE_X);
cobject_y_axis = new EditorComponentAxis(self.id, c_object_create_cached(Stuff.graphics.c_shape_axis_y, 0, 0), CollisionSpecialValues.TRANSLATE_Y);
cobject_z_axis = new EditorComponentAxis(self.id, c_object_create_cached(Stuff.graphics.c_shape_axis_z, 0, 0), CollisionSpecialValues.TRANSLATE_Z);
cobject_x_plane = new EditorComponentAxis(self.id, c_object_create_cached(Stuff.graphics.c_shape_axis_x_plane, 0, 0), CollisionSpecialValues.TRANSLATE_X);
cobject_y_plane = new EditorComponentAxis(self.id, c_object_create_cached(Stuff.graphics.c_shape_axis_y_plane, 0, 0), CollisionSpecialValues.TRANSLATE_Y);
cobject_z_plane = new EditorComponentAxis(self.id, c_object_create_cached(Stuff.graphics.c_shape_axis_z_plane, 0, 0), CollisionSpecialValues.TRANSLATE_Z);
axis_over = CollisionSpecialValues.NONE;