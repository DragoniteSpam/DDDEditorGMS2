function ThreeDGrid(width, height, depth) {
    self.width = width;
    self.height = height;
    self.depth = depth;
    
    self.buffer = buffer_create(self.width * self.height * self.depth * buffer_sizeof(buffer_f64), buffer_fixed, 8);
    
    #region fundamentals
    static Destroy = function() {
    };
    
    static Resize = function(w, h, d) {
    };
    
    static Clear = function(value) {
    };
    #endregion
    
    #region setting
    static Set = function(x, y, z, value) {
    };
    
    static SetRegion = function(x1, y1, z1, x2, y2, z2, value) {
    };
    
    static SetSphere = function(x, y, z, r, value) {
    };
    #endregion
    
    #region getting
    static Get = function(x, y, z) {
    };
    
    static GetRegionMean = function(x1, y1, z1, x2, y2, z2) {
    };
    
    static GetRegionMin = function(x1, y1, z1, x2, y2, z2) {
    };
    
    static GetRegionMax = function(x1, y1, z1, x2, y2, z2) {
    };
    
    static GetRegionSum = function(x1, y1, z1, x2, y2, z2) {
    };
    
    static GetRegionStandardDeviation = function(x1, y1, z1, x2, y2, z2) {
    };
    
    static GetSphereMean = function(x, y, z, r) {
    };
    
    static GetSphereMin = function(x, y, z, r) {
    };
    
    static GetSphereMax = function(x, y, z, r) {
    };
    
    static GetSphereSum = function(x, y, z, r) {
    };
    
    static GetSphereStandardDeviation = function(x, y, z, r) {
    };
    #endregion
    
    #region math operations
    static Add = function(x, y, z, value) {
    };
    
    static AddRegion = function(x1, y1, z1, x2, y2, z2, value) {
    };
    
    static AddSphere = function(x, y, z, r, value) {
    };
    
    static AddGridRegion = function(other_grid, x1, y1, z1, x2, y2, z2, xx1, yy1, zz1, xx2, yy2, zz2) {
    };
    
    static AddSphereRegion = function(other_grid, x, y, z, r, xx, yy, zz, rr, value) {
    };
    
    static Multiply = function(x, y, z, value) {
    };
    
    static MultiplyRegion = function(x1, y1, z1, x2, y2, z2, value) {
    };
    
    static MultiplySphere = function(x, y, z, r, value) {
    };
    
    static MultiplyGridRegion = function(other_grid, x1, y1, z1, x2, y2, z2, xx1, yy1, zz1, xx2, yy2, zz2) {
    };
    
    static MultiplyGridSphere = function(other_grid, x, y, z, r, xx, yy, zz, rr, value) {
    };
    #endregion
    
    #region lerp to
    static Lerp = function(x, y, z, value, f) {
    };
    
    static LerpRegion = function(x1, y1, z1, x2, y2, z2, value, f) {
    };
    
    static LerpSphere = function(x, y, z, r, value, f) {
    };
    
    static LerpGrid = function(other_grid, x, y, z, xx, yy, zz, f) {
    };
    
    static LerpGridRegion = function(other_grid, x1, y1, z1, x2, y2, z2, xx1, yy1, zz1, xx2, yy2, zz2, f) {
    };
    
    static LerpGridSphere = function(other_grid, x, y, z, r, xx, yy, zz, rr, value, f) {
    };
    #endregion
}