// feather ignore all
function Penguin() constructor {
    self.name = "";
    self.submeshes = [];
    
    self.collision_shapes = [];
    
    self.physical_bounds = {
        xmin: infinity,
        ymin: infinity,
        zmin: infinity,
        xmax: -infinity,
        ymax: -infinity,
        zmax: -infinity,
    };
    
    self.Clear = function() {
        for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
            if (self.vbuff != -1) vertex_delete_buffer(self.vbuff);
            if (self.reflect_vbuff != -1) vertex_delete_buffer(self.reflect_vbuff);
        }
        self.submeshes = [];
    };
    
    self.Render = function(index = undefined, upright = true) {
        if (is_numeric(index)) {
            self.submeshes[clamp(index, 0, array_length(self.submeshes) - 1)].Render(upright);
        } else {
            for (var i = 0, n = array_length(self.submeshes); i < n; i++) {
                self.submeshes[i].Render(upright);
            }
        }
    };
}

function PenguinSubmesh() constructor {
    self.name = "";
    
    self.vbuff = -1;
    self.reflect_vbuff = -1;
    
    self.material = undefined;
    
    self.Render = function(upright = false) {
        // set other material settings...
        vertex_submit(upright ? self.vbuff : self.reflect_vbuff, pr_trianglelist, self.material ? self.material.diffuse.tex : -1);
    };
}

function PenguinMaterial() constructor {
    self.name = "";
    
    self.diffuse = {
        color: c_white,
        tex: -1,
    };
    self.ambient = {
        color: c_gray,
        tex: -1,
    };
    self.normal = {
        tex: -1,
    };
    self.specular = {
        color: c_white,
        tex: -1,
        
        highlight: {
            exponent: 10,
            tex: -1,
        }
    };
}

function PenguinCollisionShape() constructor {
    self.position = { x: 0, y: 0, z: 0 };
}

function PenguinCollisionShapeBox() : PenguinCollisionShape() constructor {
    self.scale = { x: 0, y: 0, z: 0 };
    self.orientation = { x: { x: 0, y: 0, z: 0 }, y: { x: 0, y: 0, z: 0 }, z: { x: 0, y: 0, z: 0 } };
}

function PenguinCollisionShapeCapsule() : PenguinCollisionShape() constructor {
    self.radius = 1;
    self.length = 1;
    self.orientation = { x: { x: 0, y: 0, z: 0 }, y: { x: 0, y: 0, z: 0 }, z: { x: 0, y: 0, z: 0 } };
}

function PenguinCollisionShapeSphere() : PenguinCollisionShape() constructor {
    self.radius = 1;
}

function PenguinCollisionShapeTrimesh() : PenguinCollisionShape() constructor {
    self.triangles = [];
}