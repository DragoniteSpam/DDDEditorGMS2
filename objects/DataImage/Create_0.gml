event_inherited();

texture_exclude = false;

picture = -1;
picture_with_frames = -1;
npc_frames = [];

width = -1;
height = -1;
hframes = 1;
vframes = 1;
aframes = 1;
aspeed = 1;

hash = "";
source_filename = "";

LoadJSONImage = function(json) {
    self.LoadJSONBase(json);
    self.texture_exclude = json.texture_exclude;
    self.width = json.width;
    self.height = json.height;
    self.vframes = json.vframes;
    self.hframes = json.hframes;
    self.aframes = json.aframes;
    self.aspeed = json.aspeed;
    self.hash = json.hash;
    self.source_filename = json.source_filename;
};

LoadJSON = function(json) {
    self.LoadJSONImage(json);
};

LoadAsset = function(directory) {
    directory += "/";
    var guid = string_replace(self.GUID, ":", "_");
    if (file_exists(directory + guid + ".png")) {
        picture = sprite_add(directory + guid + ".png", 0, false, false, 0, 0);
    } else {
        picture = sprite_duplicate(b_tileset_magenta);
    }
    if (file_exists(directory + guid + "_strip" + string(self.hframes) + ".png")) {
        picture = sprite_add(directory + guid + ".png", -1, false, false, 0, 0);
    } else {
        picture = sprite_duplicate(b_tileset_magenta);
    }
};

SaveAsset = function(directory) {
    directory += "/";
    var guid = string_replace(self.GUID, ":", "_");
    if (sprite_exists(self.picture)) sprite_save(self.picture, 0, directory + guid + ".png");
    if (sprite_exists(self.picture_with_frames)) sprite_save_strip(self.picture_with_frames, directory + guid + "_strip" + string(self.hframes) + ".png");
    for (var i = 0, n = array_length(self.npc_frames); i < n; i++) {
        if (self.npc_frames[i]) {
            var data = buffer_create_from_vertex_buffer(self.npc_frames[i], buffer_fixed, 1);
            buffer_save(data, directory + guid + "_npc_" + string(i) + ".png");
            buffer_delete(data);
        }
    }
};

CreateJSONImage = function() {
    var json = self.CreateJSONBase();
    json.texture_exclude = self.texture_exclude;
    json.width = self.width;
    json.height = self.height;
    json.vframes = self.vframes;
    json.hframes = self.hframes;
    json.aframes = self.aframes;
    json.aspeed = self.aspeed;
    json.hash = self.hash;
    json.source_filename = self.source_filename;
    return json;
};

CreateJSON = function() {
    return self.CreateJSONImage();
};