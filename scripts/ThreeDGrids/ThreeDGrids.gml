// feather ignore all
function ThreeDGrid(width, height, depth) {
    self.width = width;
    self.height = height;
    self.depth = depth;
    
    self.buffer = buffer_create(self.width * self.height * self.depth * buffer_sizeof(buffer_f64), buffer_fixed, 8);
    
    #region fundamentals
    static getOffsetOf = function(x, y, z) {
        return (x * self.height * self.depth) + (y * self.depth) + x;
    };
    
    static Destroy = function() {
        buffer_delete(self.buffer);
    };
    
    static Resize = function(width, height, depth) {
        var new_buffer = buffer_create(width * height * depth * buffer_sizeof(buffer_f64), buffer_fixed, 8);
        // to do
        self.width = width;
        self.height = height;
        self.depth = depth;
        
        buffer_delete(self.buffer);
        self.buffer = new_buffer;
    };
    
    static Clear = function(value) {
        buffer_fill(self.buffer, 0, buffer_u64, value, buffer_get_size(self.buffer));
    };
    #endregion
    
    #region setting
    static Set = function(x, y, z, value) {
        buffer_poke(self.buffer, self.GetOffsetOf(x, y, z), buffer_f64, value);
    };
    
    static SetRegion = function(x1, y1, z1, x2, y2, z2, value) {
        // to do
    };
    
    static SetSphere = function(x, y, z, r, value) {
        // to do
    };
    
    static SetGridRegion = function(other_grid, x1, y1, z1, x2, y2, z2, xx, yy, zz) {
        // to do
    };
    
    static SetGridSphere = function(other_grid, x, y, z, r, xx, yy, zz) {
        // to do
    };
    #endregion
    
    #region getting
    static Get = function(x, y, z) {
        return buffer_peek(self.buffer, self.GetOffsetOf(x, y, z), buffer_f64);
    };
    
    static GetRegionMean = function(x1, y1, z1, x2, y2, z2) {
        // to do
    };
    
    static GetRegionMin = function(x1, y1, z1, x2, y2, z2) {
        // to do
    };
    
    static GetRegionMax = function(x1, y1, z1, x2, y2, z2) {
        // to do
    };
    
    static GetRegionSum = function(x1, y1, z1, x2, y2, z2) {
        // to do
    };
    
    static GetRegionStandardDeviation = function(x1, y1, z1, x2, y2, z2) {
        // to do
    };
    
    static GetSphereMean = function(x, y, z, r) {
        // to do
    };
    
    static GetSphereMin = function(x, y, z, r) {
        // to do
    };
    
    static GetSphereMax = function(x, y, z, r) {
        // to do
    };
    
    static GetSphereSum = function(x, y, z, r) {
        // to do
    };
    
    static GetSphereStandardDeviation = function(x, y, z, r) {
        // to do
    };
    #endregion
    
    #region math operations
    static Add = function(x, y, z, value) {
        var current = buffer_peek(self.buffer, self.GetOffsetOf(x, y, z), buffer_f64);
        buffer_poke(self.buffer, self.GetOffsetOf(x, y, z), buffer_f64, value + current);
    };
    
    static AddRegion = function(x1, y1, z1, x2, y2, z2, value) {
        // to do
    };
    
    static AddSphere = function(x, y, z, r, value) {
        // to do
    };
    
    static AddGridRegion = function(other_grid, x1, y1, z1, x2, y2, z2, xx, yy, zz) {
        // to do
    };
    
    static AddGridSphere = function(other_grid, x, y, z, r, xx, yy, zz, value) {
        // to do
    };
    
    static Multiply = function(x, y, z, value) {
        var current = buffer_peek(self.buffer, self.GetOffsetOf(x, y, z), buffer_f64);
        buffer_poke(self.buffer, self.GetOffsetOf(x, y, z), buffer_f64, value * current);
    };
    
    static MultiplyRegion = function(x1, y1, z1, x2, y2, z2, value) {
        // to do
    };
    
    static MultiplySphere = function(x, y, z, r, value) {
        // to do
    };
    
    static MultiplyGridRegion = function(other_grid, x1, y1, z1, x2, y2, z2, xx, yy, zz) {
        // to do
    };
    
    static MultiplyGridSphere = function(other_grid, x, y, z, r, xx, yy, zz) {
        // to do
    };
    #endregion
    
    #region lerp to
    static Lerp = function(x, y, z, value, f) {
        var current = buffer_peek(self.buffer, self.GetOffsetOf(x, y, z), buffer_f64);
        buffer_poke(self.buffer, self.GetOffsetOf(x, y, z), buffer_f64, lerp(current, value, f));
    };
    
    static LerpRegion = function(x1, y1, z1, x2, y2, z2, value, f) {
        // to do
    };
    
    static LerpSphere = function(x, y, z, r, value, f) {
        // to do
    };
    
    static LerpGrid = function(other_grid, x, y, z, xx, yy, zz, f) {
        // to do
    };
    
    static LerpGridRegion = function(other_grid, x1, y1, z1, x2, y2, z2, xx1, yy1, zz, xx, yy, f) {
        // to do
    };
    
    static LerpGridSphere = function(other_grid, x, y, z, r, xx, yy, zz, f) {
        // to do
    };
    #endregion
}