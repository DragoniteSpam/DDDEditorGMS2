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

SaveAsset = function(directory) {
    
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