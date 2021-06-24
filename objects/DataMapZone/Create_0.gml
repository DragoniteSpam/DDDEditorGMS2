var map = Stuff.map.active_map;
var map_contents = map.contents;
ds_list_add(map_contents.all_zones, id);

/* s */ name = "Zone " + string(ds_list_size(map_contents.all_zones));
/* s */ ztype = -1;
/* s */ zone_priority = 100;        // u16

/* s */ x1 = 0;                     // f32
/* s */ y1 = 0;                     // f32
/* s */ z1 = 0;                     // f32
/* s */ x2 = 1;                     // f32
/* s */ y2 = 1;                     // f32
/* s */ z2 = 1;                     // f32

// this is updated with z1 just so that it can interface with Selection instances
zz = 0;

zone_edit_script = null;
cobject = noone;
cshape = noone;
editor_color = c_white;

// this is the base class, do not instantiate
save_script = null;

Render = function() {
    var minx = min(self.x1, self.x2);
    var miny = min(self.y1, self.y2);
    var minz = min(self.z1, self.z2);
    var maxx = max(self.x2, self.x2);
    var maxy = max(self.y2, self.y2);
    var maxz = max(self.z2, self.z2);
    
    var x1 = minx * TILE_WIDTH;
    var y1 = miny * TILE_HEIGHT;
    var z1 = minz * TILE_DEPTH;
    // the outer corner of the cube is already at (32, 32, 32) so we need to
    // compensate for that
    var cube_bound = 32;
    var x2 = maxx * TILE_WIDTH - cube_bound;
    var y2 = maxy * TILE_HEIGHT - cube_bound;
    var z2 = maxz * TILE_DEPTH - cube_bound;
    var zone_color = (Stuff.map.selected_zone == id) ? c_array_zone_selected : editor_color;
    
    shader_set(shd_bounding_box);
    shader_set_uniform_f(shader_get_uniform(shd_bounding_box, "actual_color"), (zone_color & 0xff) / 0xff, ((zone_color > 8) & 0xff) / 0xff, ((zone_color >> 16) & 0xff) / 0xff);
    shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
        x1, y1, z1,
        x2, y1, z1,
        x1, y2, z1,
        x2, y2, z1,
        x1, y1, z2,
        x2, y1, z2,
        x1, y2, z2,
        x2, y2, z2,
    ]);
    
    vertex_submit(Stuff.graphics.indexed_cage_full, pr_trianglelist, -1);
    shader_reset();
};

LoadJSONZone = function(source) {
    self.LoadJSONBase(source);
    self.x1 = bounds.x1;
    self.y1 = bounds.y1;
    self.z1 = bounds.z1;
    self.x2 = bounds.x2;
    self.y2 = bounds.y2;
    self.z2 = bounds.z2;
    self.zone_priority = bounds.priority;
};

LoadJSON = function(source) {
    self.LoadJSONZone(source);
};

CreateJSONZone = function() {
    return {
        bounds: {
            x1: self.x1,
            y1: self.y1,
            z1: self.z1,
            x2: self.x2,
            y2: self.y2,
            z2: self.z2,
        },
        type: self.ztype,
        priority: self.zone_priority,
    };
};

CreateJSON = function() {
    return self.CreateJSONZone();
};