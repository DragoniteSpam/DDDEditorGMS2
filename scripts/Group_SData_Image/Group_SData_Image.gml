function DataImage(source) : SData(source) constructor {
    self.texture_exclude = false;
    
    self.picture = -1;
    self.npc_frames = [];
    
    self.width = -1;
    self.height = -1;
    self.hframes = 1;
    self.vframes = 1;
    self.aframes = 1;
    self.aspeed = 1;
    
    self.flag_unused = false;
    
    // don't save these to the project - gets refreshed every time you export
    self.packed = {
        x: 0,
        y: 0,
        w: 0,
        h: 0,
    };
    
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
    
    self.LoadAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        if (file_exists(directory + guid + ".png")) {
            self.picture = sprite_add(directory + guid + ".png", 0, false, false, 0, 0);
        } else {
            self.picture = sprite_duplicate(b_tileset_magenta);
        }
        data_image_npc_frames(self);
    };
    
    self.Reload = function() {
        if (!file_exists(self.source_filename)) return;
        sprite_delete(self.picture);
        self.picture = sprite_add(self.source_filename, 0, false, false, 0, 0);
    };
    
    self.SaveAsset = function(directory) {
        directory += "/";
        var guid = string_replace(self.GUID, ":", "_");
        if (sprite_exists(self.picture)) sprite_save(self.picture, 0, directory + guid + ".png");
    };
    
    self.ExportImage = function(buffer, include_image) {
        self.ExportBase(buffer);
        buffer_write(buffer, buffer_u16, self.width);
        buffer_write(buffer, buffer_u16, self.height);
        buffer_write(buffer, buffer_u16, self.hframes);
        buffer_write(buffer, buffer_u16, self.vframes);
        buffer_write(buffer, buffer_u16, self.aframes);
        buffer_write(buffer, buffer_u16, self.aspeed);
        buffer_write(buffer, buffer_bool, include_image && sprite_exists(self.picture));
        if (include_image && sprite_exists(self.picture)) {
            buffer_write_sprite(buffer, self.picture);
        }
        // packed data (will default to 0s)
        buffer_write(buffer, buffer_f32, self.packed.x);
        buffer_write(buffer, buffer_f32, self.packed.y);
        buffer_write(buffer, buffer_f32, self.packed.w);
        buffer_write(buffer, buffer_f32, self.packed.h);
    };
    
    self.SaveToFile = function(filename) {
        sprite_save(self.picture, 0, filename);
    };
    
    self.Export = function(buffer, include_image = true) {
        self.ExportImage(buffer, include_image);
    };
    
    self.Resize = function(w, h) {
        w = clamp(w, 1, 0x4000);
        h = clamp(h, 1, 0x4000);
        var surface = surface_create(w, h);
        surface_set_target(surface);
        draw_clear_alpha(c_black, 0);
        gpu_set_blendmode(bm_add);
        gpu_set_blendenable(false);
        draw_sprite_stretched(self.picture, 0, 0, 0, w, h);
        gpu_set_blendmode(bm_normal);
        gpu_set_blendenable(true);
        surface_reset_target();
        sprite_delete(self.picture);
        self.picture = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
        surface_free(surface);
        self.width = w;
        self.height = h;
        self.vframes = 1;
        self.hframes = 1;
    };
    
    // we dont have a SaveJSON here because we're literally just saving the
    // struct verbatim
    
    self.baseDestroy = self.Destroy;
    self.Destroy = function() {
        self.baseDestroy();
        if (self.picture) sprite_delete(self.picture);
        
        for (var i = 0; i < array_length(self.npc_frames); i++) {
            vertex_delete_buffer(self.npc_frames[i]);
        }
    };
}

function DataImageTileset(source = undefined) : DataImage(source) constructor {
    self.image_flags = [[]];
    
    if (is_struct(source)) {
        try {
            self.image_flags = source.image_flags;
        } catch (e) {
            self.flags = [[]];
        };
    }
    
    self.Export = function(buffer) {
        self.ExportImage(buffer, true);
        var w = array_length(self.image_flags);
        var h = array_length(self.image_flags[0]);
        buffer_write(buffer, buffer_u16, w);
        buffer_write(buffer, buffer_u16, h);
        for (var i = 0; i < w; i++) {
            for (var j = 0; j < h; j++) {
                buffer_write(buffer, buffer_flag, self.image_flags[i][j]);
            }
        }
    };
    
    self.Import = function(filename) {
        self.name = filename_change_ext(filename_name(filename), "");
        self.source_filename = filename;
        
        internal_name_generate(self, PREFIX_GRAPHIC_TILESET + string_lettersdigits(filename_change_ext(filename_name(self.source_filename), "")));
        
        self.picture = sprite_add(self.source_filename, 0, false, false, 0, 0);
        self.hash = md5_file(filename);
        
        if (!sprite_exists(self.picture)) {
            self.picture = sprite_duplicate(b_tileset_magenta);
            wtf("Missing tileset image; using default instead: " + self.source_filename);
        }
        
        self.width = sprite_get_width(self.picture);
        self.height = sprite_get_height(self.picture);
        self.hframes = self.width div TILE_WIDTH;
        self.vframes = self.height div TILE_HEIGHT;
        self.image_flags = array_create_2d(self.hframes, self.vframes, 0);
    };
    
    self.SetFromInternal = function(sprite) {
        self.picture = sprite;
        self.width = sprite_get_width(self.picture);
        self.height = sprite_get_height(self.picture);
        self.hframes = self.width div TILE_WIDTH;
        self.vframes = self.height div TILE_HEIGHT;
        self.image_flags = array_create_2d(self.hframes, self.vframes, 0);
    };
};