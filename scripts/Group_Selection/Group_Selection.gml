function Selection(x, y, z) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    
    array_push(Stuff.map.selection, self);
    
    static onmousedrag = null;
    static render = null;
    static area = null;
    static foreach_cell = null;
    static selected_determination = null;
    static selected_border_determination = null;
}

function SelectionSingle(x, y, z) : Selection(x, y, z) constructor {
    static area = function() {
        return 1;
    };
    
    static render = function() {
        var xx = self.x * TILE_WIDTH;
        var yy = self.y * TILE_HEIGHT;
        var zz = self.z * TILE_DEPTH;
        
        shader_set(shd_bounding_box);
        shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), [1, 0, 0, 1]);
        shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "offsets"), [
            xx, yy, zz,
            xx, yy, zz,
            xx, yy, zz,
            xx, yy, zz,
            xx, yy, zz,
            xx, yy, zz,
            xx, yy, zz,
            xx, yy, zz,
        ]);
        
        vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
        shader_reset();
    };
    
    static foreach_cell = function(processed, script, params) {
        var str = string(self.x) + "," + string(self.y) + "," + string(self.z);
        if (!processed[$ str]) {
            processed[$ str] = true;
            script(self.x, self.y, self.z, params);
        }
    };
    
    static selected_determination = function(entity) {
        return (self.x == entity.xx && self.y == entity.yy) && (!Settings.view.threed || self.z == entity.zz);
    };
    
    static selected_border_determination = function(entity) {
        var minx = self.x - 1;
        var miny = self.y - 1;
        var minz = self.z - 1;
        var maxx = self.x + 1;
        var maxy = self.y + 1;
        var maxz = self.z + 1;
        return is_clamped(entity.xx, minx, maxx) && is_clamped(entity.yy, miny, maxy) && (!Settings.view.threed || is_clamped(entity.zz, minz, maxz));
    };
}

function SelectionRectangle(x, y, z, x2 = x, y2 = y, z2 = z) : Selection(x, y, z) constructor {
    self.x2 = x2;
    self.y2 = y2;
    self.z2 = z2 + 1;
    
    static onmousedrag = function(x, y) {
        self.x2 = x;
        self.y2 = y;
    };
    
    static area = function() {
        return (self.x - x2) * (self.y - y2);
    };
    
    static render = function() {
        var minx = min(self.x, self.x2);
        var miny = min(self.y, self.y2);
        var minz = min(self.z, self.z2);
        var maxx = max(self.x, self.x2);
        var maxy = max(self.y, self.y2);
        var maxz = max(self.z, self.z2);
        
        var x1 = minx * TILE_WIDTH;
        var y1 = miny * TILE_HEIGHT;
        var z1 = minz * TILE_DEPTH;
        // the outer corner of the cube is already at (32, 32, 32) so we need to
        // compensate for that
        var cube_bound = 32;
        var x2 = maxx * TILE_WIDTH - cube_bound;
        var y2 = maxy * TILE_HEIGHT - cube_bound;
        var z2 = maxz * TILE_DEPTH - cube_bound;
        
        shader_set(shd_bounding_box);
        shader_set_uniform_f_array(shader_get_uniform(shd_bounding_box, "actual_color"), [1, 0, 0, 1]);
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
        
        vertex_submit(Stuff.graphics.indexed_cage, pr_trianglelist, -1);
        shader_reset();
    };
    
    static foreach_cell = function(processed, script, params) {
        var minx = min(self.x, x2);
        var miny = min(self.y, y2);
        var minz = min(self.z, z2);
        var maxx = max(self.x, x2);
        var maxy = max(self.y, y2);
        var maxz = max(self.z, z2);
        
        for (var i = minx; i < maxx; i++) {
            for (var j = miny; j < maxy; j++) {
                for (var k = minz; k < maxz; k++) {
                    var str = string(i) + ","+string(j) + "," + string(k);
                    if (!variable_struct_exists(processed, str)) {
                        processed[$ str] = true;
                        script(i, j, k, params);
                    }
                }
            }
        }
    };
    
    static selected_determination = function(entity) {
        var minx = min(self.x, x2);
        var miny = min(self.y, y2);
        var minz = min(self.z, z2);
        var maxx = max(self.x, x2);
        var maxy = max(self.y, y2);
        var maxz = max(self.z, z2);
        
        // exclude the outer edge but don't have a negative area
        var maxex = max(minx, maxx - 1);
        var maxey = max(miny, maxy - 1);
        var maxez = max(minz, maxz - 1);
        
        return (is_clamped(entity.xx, minx, maxex) && is_clamped(entity.yy, miny, maxey)) && (!Settings.view.threed || is_clamped(entity.zz, minz, maxez));
    };
    
    static selected_border_determination = function(entity) {
        var minx = min(self.x, x2) - 1;
        var miny = min(self.y, y2) - 1;
        var minz = min(self.z, z2) - 1;
        var maxx = max(self.x, x2) + 1;
        var maxy = max(self.y, y2) + 1;
        var maxz = max(self.z, z2) + 1;
        // exclude the outer edge but don't have a negative area
        var maxex = max(minx, maxx - 1);
        var maxey = max(miny, maxy - 1);
        var maxez = max(minz, maxz - 1);
        return (is_clamped(entity.xx, minx, maxex) && is_clamped(entity.yy, miny, maxey)) && (!Settings.view.threed || is_clamped(entity.zz, minz, maxez));
    };
}