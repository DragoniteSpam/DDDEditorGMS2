function DataImage(source) : SData(source) constructor {
    self.texture_exclude = false;
    
    self.picture = -1;
    self.picture_with_frames = -1;
    self.npc_frames = [];
    
    self.width = -1;
    self.height = -1;
    self.hframes = 1;
    self.vframes = 1;
    self.aframes = 1;
    self.aspeed = 1;
    
    self.hash = "";
    self.source_filename = "";
    
    if (is_struct(source)) {
        self.texture_exclude = source.texture_exclude;
        self.width = source.width;
        self.height = source.height;
        self.vframes = source.vframes;
        self.hframes = source.hframes;
        self.aframes = source.aframes;
        self.aspeed = source.aspeed;
        self.hash = source.hash;
        self.source_filename = source.source_filename;
    }
    
    static LoadAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        if (file_exists(directory + guid + ".png")) {
            self.picture = sprite_add(directory + guid + ".png", 0, false, false, 0, 0);
        } else {
            self.picture = sprite_duplicate(b_tileset_magenta);
        }
        if (file_exists(directory + guid + "_strip" + string(self.hframes) + ".png")) {
            self.picture_with_frames = sprite_add(directory + guid + ".png", -1, false, false, 0, 0);
        } else {
            self.picture_with_frames = sprite_duplicate(b_tileset_magenta);
        }
        data_image_npc_frames(self);
    };
    
    static SaveAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        if (sprite_exists(self.picture)) sprite_save(self.picture, 0, directory + guid + ".png");
        if (sprite_exists(self.picture_with_frames)) sprite_save_strip(self.picture_with_frames, directory + guid + "_strip" + string(self.hframes) + ".png");
    };
    
    static CreateJSONImage = function() {
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
    
    static CreateJSON = function() {
        return self.CreateJSONImage();
    };
    
    self.baseDestroy = self.Destroy;
    self.Destroy = function() {
        self.baseDestroy();
        if (self.picture) sprite_delete(self.picture);
        if (self.picture_with_frames) sprite_delete(self.picture_with_frames);
        
        for (var i = 0; i < array_length(self.npc_frames); i++) {
            vertex_delete_buffer(self.npc_frames[i]);
        }
    };
}

function DataImageTileset(source) : DataImage(source) constructor {
    self.flags = [[]];
    
    if (is_struct(source)) {
        self.flags = source.flags;
    }
    
    static CreateJSONTS = function() {
        var json = self.CreateJSONImage();
        json.flags = self.flags;
        return json;
    };
    
    static CreateJSON = function() {
        return self.CreateJSONTS();
    };
};