function Rectangle(x1, y1, x2, y2) constructor {
    self.x1 = x1;
    self.x2 = x2;
    self.y1 = y1;
    self.y2 = y2;
    
    static W = function() {
        return abs(self.x2 - self.x1);
    };
    
    static H = function() {
        return abs(self.y2 - self.y1);
    };
    
    static X1 = function() {
        return min(self.x1, self.x2);
    };
    
    static Y1 = function() {
        return min(self.y1, self.y2);
    };
    
    static X2 = function() {
        return max(self.x1, self.x2);
    };
    
    static Y2 = function() {
        return max(self.y1, self.y2);
    };
    
    static Area = function() {
        return (self.x2 - self.x1) * (self.y2 - self.y1);
    };
    
    static Contains = function(x, y) {
        return point_in_rectangle(x, y, min(self.x1, self.x2), min(self.y1, self.y1), max(self.x1, self.x2), max(self.y1, self.y2));
    };
}