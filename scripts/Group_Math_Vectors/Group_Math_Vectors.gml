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

function BoundingBox(x1, y1, z1, x2, y2, z2) constructor {
    self.x1 = x1;
    self.y1 = y1;
    self.z1 = z1;
    self.x2 = x2;
    self.y2 = y2;
    self.z2 = z2;
    
    static Chunk = function(scalex, scaley = scalex, scalez = scalex) {
        return new BoundingBox(
            self.x1 / scalex, 
            self.y1 / scaley,
            self.z1 / scalez,
            self.x2 / scalex,
            self.y2 / scaley,
            self.z2 / scalez,
        );
    };
    
    // i'm not sorry
    static Clone = function() {
        return self.Chunk(1);
    };
    
    static GetAllChunks = function(sizex, sizey = sizex, sizez = sizex) {
        if (sizez == 0 || sizey == 0 || sizez == 0) {
            return [self.Clone()];
        }
        
        var chunks = array_create(self.GetContainedChunks(sizex, sizey));
        var index = 0;
        for (var i = self.x1; i < self.x2; i += sizex) {
            for (var j = self.y1; j < self.y2; j += sizey) {
                for (var k = self.z1; k < self.z2; k += sizez) {
                    chunks[index++] = new BoundingBox(i, j, k, i + sizex, j + sizey, k + sizez);
                }
            }
        }
        
        return chunks;
    };
    
    static Center = function() {
        var dim = self.GetAbsDimensions();
        return new BoundingBox(self.x1 - dim.x / 2, self.y1 - dim.y / 2, self.z1 - dim.z / 2, self.x2 - dim.x / 2, self.y2 - dim.y / 2, self.z2 - dim.z / 2);
    };
    
    static GetAbsDimensions = function() {
        return { x: abs(self.x2 - self.x1), y: abs(self.y2 - self.y1), z: abs(self.z2 - self.z1) };
    };
    
    static GetContainedChunks = function(sizex, sizey = sizex) {
        var dim = self.GetAbsDimensions();
        return ceil(dim.x / sizex) * ceil(dim.y / sizey);
    };
    
    static toString = function() {
        return "(" + string(self.x1) + ", " + string(self.y1) + ", " + string(self.z1) + ") to (" + string(self.x2) + ", " + string(self.y2) + ", " + string(self.z2) + ")";
    };
}