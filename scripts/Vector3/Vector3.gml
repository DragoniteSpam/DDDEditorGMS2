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