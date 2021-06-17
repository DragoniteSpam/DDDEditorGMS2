event_inherited();

save_script = null;
load_script = null;
render = null;
sprite = spr_light_direction;
audio_type = AudioTypes.NONE;

// specific

instance_deactivate_object(id);

LoadJSONComponentAudio = function(source) {
    self.LoadJSONComponent(source);
    self.audio_type = source.audio.type;
};

LoadJSON = function(source) {
    self.LoadJSONComponentAudio(source);
};

CreateJSONAudio = function() {
    var json = self.CreateJSONComponent();
    json.audio = {
        type: self.audio_type,
    };
    return json;
};

CreateJSON = function() {
    return self.CreateJSONAudio();
};
