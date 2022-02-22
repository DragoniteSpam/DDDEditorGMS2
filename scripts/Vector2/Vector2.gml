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