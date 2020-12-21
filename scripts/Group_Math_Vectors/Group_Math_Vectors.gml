// these are for utility; please don't delete them just because they're not used
// in the program anywhere
enum vec3 {
    xx, yy, zz
}

function vector3_normalize(vector) {
    gml_pragma("forceinline");
    var l = point_distance_3d(0, 0, 0, vector[0], vector[1], vector[2]);
    if (l != 0) {
        return [vector[0] / l, vector[1] / l, vector[2] / l];
    }
    return [0, 0, 1];
}

function vec2(x, y) constructor {
    self.x = x;
    self.y = y;
}

function Vertex() constructor {
    self.position = {
        x: 0, y: 0, z: 0
    };
    self.normal = {
        x: 0, y: 0, z: 1
    };
    self.tex = new vec2(0, 0);
    self.color = c_white;
    self.alpha = 1;
    self.extra = 0;
}

function Triangle() constructor {
    self.vertex = [new Vertex(), new Vertex(), new Vertex()];
}