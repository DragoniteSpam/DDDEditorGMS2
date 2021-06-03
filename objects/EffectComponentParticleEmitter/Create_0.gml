event_inherited();

save_script = null;
load_script = null;
render = null;
sprite = spr_light_direction;
particle_type = ParticleTypes.NONE;

// specific

instance_deactivate_object(id);

CreateJSONParticle = function() {
    var json = self.CreateJSONComponent();
    json.particle = {
        type: self.particle_type,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONParticle();
};
