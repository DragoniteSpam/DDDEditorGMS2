function Vector2(x, y) constructor {
    self.x = x;
    self.y = y;
    
    static Add = function(val) {
        return new Vector2(self.x + val.x, self.y + val.y);
    };
    
    static Sub = function(val) {
        return new Vector2(self.x - val.x, self.y - val.y);
    };
    
    static Mul = function(val) {
        if (is_numeric(val)) {
            return new Vector2(self.x * val, self.y * val);
        }
        return new Vector2(self.x * val.x, self.y * val.y);
    };
    
    static Div = function(val) {
        if (is_numeric(val)) {
            return new Vector2(self.x / val, self.y / val);
        }
        return new Vector2(self.x / val.x, self.y / val.y);
    };
    
    static Magnitude = function() {
        return point_distance(0, 0, self.x, self.y);
    };
    
    static DistanceTo = function(val) {
        return point_distance(val.x, val.y, self.x, self.y);
    };
    
    static Dot = function(val) {
        return dot_product(self.x, self.y, val.x, val.y);
    };
    
    static Equals = function(val) {
        return (self.x == val.x) && (self.y == val.y);
    };
    
    static Normalize = function() {
        var mag = self.Magnitude();
        return new Vector2(self.x / mag, self.y / mag);
    };
    
    static Abs = function() {
        return new Vector2(abs(self.x), abs(self.y));
    };
}

function Vector3(x, y, z) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    
    static Add = function(val) {
        return new Vector3(self.x + val.x, self.y + val.y, self.z + val.z);
    };
    
    static Sub = function(val) {
        return new Vector3(self.x - val.x, self.y - val.y, self.z - val.z);
    };
    
    static Mul = function(val) {
        if (is_numeric(val)) {
            return new Vector3(self.x * val, self.y * val, self.z * val);
        }
        return new Vector3(self.x * val.x, self.y * val.y, self.z * val.z);
    };
    
    static Div = function(val) {
        if (is_numeric(val)) {
            return new Vector3(self.x / val, self.y / val, self.z / val);
        }
        return new Vector3(self.x / val.x, self.y / val.y, self.z / val.z);
    };
    
    static Magnitude = function() {
        return point_distance_3d(0, 0, 0, self.x, self.y, self.z);
    };
    
    static DistanceTo = function(val) {
        return point_distance_3d(val.x, val.y, val.z, self.x, self.y, self.z);
    };
    
    static Dot = function(val) {
        return dot_product_3d(self.x, self.y, self.z, val.x, val.y, val.z);
    };
    
    static Cross = function(val) {
        return new Vector3(self.y * val.z - val.y * self.z, self.z * val.x - val.z * self.x, self.x * val.y - val.x * self.y);
    };
    
    static Equals = function(val) {
        return (self.x == val.x) && (self.y == val.y) && (self.z == val.z);
    };
    
    static Normalize = function() {
        var mag = self.Magnitude();
        return new Vector3(self.x / mag, self.y / mag, self.z / mag);
    };
    
    static Abs = function() {
        return new Vector3(abs(self.x), abs(self.y), abs(self.z));
    };
    
    static Project = function(direction) {
        var dot = self.Dot(direction);
        var mag = direction.Magnitude();
        return direction.Mul(dot / (mag * mag));
    };
    
    static Rotate = function(axis, angle) {
        axis = axis.Normalize();
        return self.Mul(dcos(angle)).Add(axis.Cross(self).Mul(dsin(angle))).Add(axis.Mul(axis.Dot(self)).Mul(1 - dcos(angle))).Normalize();
    }
}

function Vector4(x, y, z, w) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    self.w = w;
    
    static Add = function(val) {
        return new Vector4(self.x + val.x, self.y + val.y, self.z + val.z, self.w + val.w);
    };
    
    static Sub = function(val) {
        return new Vector4(self.x - val.x, self.y - val.y, self.z - val.z, self.w - val.w);
    };
    
    static Mul = function(val) {
        if (is_numeric(val)) {
            return new Vector4(self.x * val, self.y * val, self.z * val, self.w * val);
        }
        return new Vector4(self.x * val.x, self.y * val.y, self.z * val.z, self.w * val.w);
    };
    
    static Div = function(val) {
        if (is_numeric(val)) {
            return new Vector4(self.x / val, self.y / val, self.z / val, self.w / val);
        }
        return new Vector4(self.x / val.x, self.y / val.y, self.z / val.z, self.w / val.w);
    };
    
    static Magnitude = function() {
        static zero = new Vector4(0, 0, 0, 0);
        return self.DistanceTo(zero);
    };
    
    static DistanceTo = function(val) {
        var dx = val.x - self.x;
        var dy = val.y - self.y;
        var dz = val.z - self.z;
        var dw = val.w - self.w;
        return sqrt(dx * dx + dy * dy + dz * dz + dw * dw);
    };
    
    static Dot = function(val) {
        return self.x * val.x + self.y * val.y + self.z * val.z + self.w * val.w;
    };
    
    static Equals = function(val) {
        return (self.x == val.x) && (self.y == val.y) && (self.z == val.z) && (self.w == val.w);
    };
    
    static Normalize = function() {
        var mag = self.Magnitude();
        return new Vector4(self.x / mag, self.y / mag, self.z / mag, self.w / mag);
    };
    
    static Abs = function() {
        return new Vector4(abs(self.x), abs(self.y), abs(self.z), abs(self.w));
    };
}

// these are for utility; please don't delete them just because they're not used
// in the program anywhere
function Vertex() constructor {
    self.position = new Vector3(0, 0, 0);
    self.normal = new Vector3(0, 0, 1);
    self.tex = new Vector2(0, 0);
    self.color = c_white;
    self.alpha = 1;
    self.tangent = new Vector3(0, 0, 0);
    self.bitangent = new Vector3(0, 0, 0);
    self.barycentric = new Vector3(0, 0, 0);
}

function Triangle() constructor {
    self.vertex = [new Vertex(), new Vertex(), new Vertex()];
    self.vertex[0].barycentric.x = 1;
    self.vertex[1].barycentric.y = 1;
    self.vertex[2].barycentric.z = 1;
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
        return new Vector3(abs(self.x2 - self.x1), abs(self.y2 - self.y1), abs(self.z2 - self.z1));
    };
    
    static GetContainedChunks = function(sizex, sizey = sizex) {
        var dim = self.GetAbsDimensions();
        return ceil(dim.x / sizex) * ceil(dim.y / sizey);
    };
    
    static toString = function() {
        return "(" + string(self.x1) + ", " + string(self.y1) + ", " + string(self.z1) + ") to (" + string(self.x2) + ", " + string(self.y2) + ", " + string(self.z2) + ")";
    };
}